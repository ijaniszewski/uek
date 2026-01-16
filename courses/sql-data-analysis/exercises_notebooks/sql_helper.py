"""Shared SQL helper utilities for the SQL exercise notebooks.

The `run_sql` function executes a SQL statement inside the existing
`sql-data-analysis-init-db` Docker image and prints tabular results.
Configuration is driven by environment variables (loaded from the nearest
`.env` file) so notebooks can be portable across machines.
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path
from textwrap import dedent
from typing import Dict

_DEFAULT_NETWORK = "sql-data-analysis_db_network_uek"
_NETWORK_ENV_VAR = "SQL_DOCKER_NETWORK"
_IMAGE_ENV_VAR = "SQL_DOCKER_IMAGE"
_DEFAULT_IMAGE = "sql-data-analysis-init-db"

_SERVER_ENV_VAR = "SQL_SERVER"
_DEFAULT_SERVER = "sqlserver"
_DB_CONTAINER_VAR = "SQL_DB_CONTAINER_NAME"
_DEFAULT_DB_CONTAINER = "sqlserver_db-uek"

_PORT_ENV_VAR = "SQL_PORT"
_DEFAULT_PORT = "1433"
_USER_ENV_VAR = "SQL_USER"
_DEFAULT_USER = "sa"
_PASSWORD_ENV_VAR = "SQL_PASSWORD"
_DEFAULT_PASSWORD = "YourStrong@Passw0rd"
_DATABASE_ENV_VAR = "SQL_DATABASE"
_DEFAULT_DATABASE = "university"

_ENV_FILENAME = ".env"
_ENV_LOADED = False


def _get_python_executor(
    server: str, port: str, user: str, password: str, database: str
) -> str:
    return dedent(
        f"""
    import pymssql
    import sys

    try:
        conn = pymssql.connect(
            server='{server}',
            port={port},
            user='{user}',
            password='{password}',
            database='{database}',
            autocommit=True
        )
        cursor = conn.cursor()

        with open('/query.sql', 'r', encoding='utf-8') as f:
            sql = f.read()

        cursor.execute(sql)

        if cursor.description:
            columns = [desc[0] for desc in cursor.description]
            rows = cursor.fetchall()

            print(" | ".join(str(col) for col in columns))
            print("-" * (sum(len(str(col)) for col in columns) + len(columns) * 3 - 1))

            if rows:
                for row in rows:
                    print(" | ".join(str(val) if val is not None else "NULL" for val in row))
                print(f"\\n({{len(rows)}} row(s) returned)")
            else:
                print("(0 rows returned)")
        else:
            print("Command executed successfully.")

        cursor.close()
        conn.close()

    except Exception as exc:  # pragma: no cover - surfaced in notebook output
        print(f"Error: {{exc}}", file=sys.stderr)
        sys.exit(1)
    """
    )


def _load_first_env_file(filename: str = _ENV_FILENAME) -> None:
    """Populate os.environ defaults from the closest .env file."""
    global _ENV_LOADED
    if _ENV_LOADED:
        return

    current = Path.cwd().resolve()
    for directory in (current, *current.parents):
        env_path = directory / filename
        if not env_path.is_file():
            continue
        try:
            with env_path.open(encoding="utf-8") as env_file:
                for raw_line in env_file:
                    line = raw_line.strip()
                    if not line or line.startswith("#") or "=" not in line:
                        continue
                    key, value = line.split("=", 1)
                    os.environ.setdefault(key.strip(), value.strip())
        except OSError:
            pass
        break

    _ENV_LOADED = True


def get_config() -> Dict[str, str]:
    """Return the effective helper configuration and validate environment."""
    print("DEBUG: get_config() called. Validating environment...")
    _load_first_env_file()
    config = {
        "docker_network": os.environ.get(_NETWORK_ENV_VAR, _DEFAULT_NETWORK),
        "docker_image": os.environ.get(_IMAGE_ENV_VAR, _DEFAULT_IMAGE),
        "server": os.environ.get(_SERVER_ENV_VAR, _DEFAULT_SERVER),
        "db_container": os.environ.get(_DB_CONTAINER_VAR, _DEFAULT_DB_CONTAINER),
        "port": os.environ.get(_PORT_ENV_VAR, _DEFAULT_PORT),
        "user": os.environ.get(_USER_ENV_VAR, _DEFAULT_USER),
        "password": os.environ.get(_PASSWORD_ENV_VAR, _DEFAULT_PASSWORD),
        "database": os.environ.get(_DATABASE_ENV_VAR, _DEFAULT_DATABASE),
    }

    # 1. Validate Docker availability
    try:
        subprocess.run(
            ["docker", "--version"],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        raise RuntimeError(
            "Docker is not available. Please install Docker and ensure it is in your PATH."
        )

    # 2. Validate Image
    try:
        subprocess.run(
            ["docker", "image", "inspect", config["docker_image"]],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"Docker image '{config['docker_image']}' not found.\n"
            "Please build the image (e.g. `docker-compose build`)."
        )

    # 3. Validate Network
    try:
        proc = subprocess.run(
            ["docker", "network", "inspect", config["docker_network"]],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError:
        raise RuntimeError(
            f"Docker network '{config['docker_network']}' not found.\n"
            "Please start the environment (e.g. `docker-compose up -d`)."
        )

    # 4. Validate Database Container is Running
    db_container = config["db_container"]
    try:
        inspect_proc = subprocess.run(
            ["docker", "inspect", "-f", "{{.State.Running}}", db_container],
            capture_output=True,
            text=True,
            check=False,
        )
        if inspect_proc.returncode != 0:
            raise RuntimeError(
                f"Database container '{db_container}' does not exist.\n"
                "Please start the environment (e.g. `docker-compose up -d`)."
            )

        is_running = inspect_proc.stdout.strip().lower() == "true"
        if not is_running:
            raise RuntimeError(
                f"Database container '{db_container}' is not running.\n"
                "Please start it (e.g. `docker start {db_container}` or `docker-compose up -d`)."
            )

    except FileNotFoundError:
        # Should be caught by step 1, but just in case
        raise RuntimeError("Docker command not found.")

    # 5. Check if DB container is attached to the network
    # We parse the network inspect output from step 3
    try:
        network_data = json.loads(proc.stdout)
        # network_data is a list; check first element's Containers
        if network_data and "Containers" in network_data[0]:
            containers = network_data[0]["Containers"]
            # The keys are container IDs, values have Name property.
            # We need to check if any container name matches our db_container
            # Note: network inspect names often don't include the slash, but sometimes do?
            # actually usually 'Name': 'adminer-uek'

            # Get the exact ID of the db container
            db_id_proc = subprocess.run(
                ["docker", "inspect", "-f", "{{.Id}}", db_container],
                capture_output=True,
                text=True,
            )
            if db_id_proc.returncode == 0:
                db_id = db_id_proc.stdout.strip()
                if db_id not in containers:
                    print(
                        f"WARNING: Database container '{db_container}' is running but NOT attached to network '{config['docker_network']}'.\n"
                        f"It won't be reachable. Check your docker-compose configuration.",
                        file=sys.stderr,
                    )

    except (json.JSONDecodeError, KeyError, IndexError):
        pass

    return config


def run_sql(
    query: str,
    description: str = "Query",
    *,
    docker_network: str | None = None,
    container_image: str | None = None,
) -> None:
    """Execute *query* inside the configured Docker container and print results."""
    _load_first_env_file()

    network = docker_network or os.environ.get(_NETWORK_ENV_VAR, _DEFAULT_NETWORK)
    image = container_image or os.environ.get(_IMAGE_ENV_VAR, _DEFAULT_IMAGE)

    server = os.environ.get(_SERVER_ENV_VAR, _DEFAULT_SERVER)
    port = os.environ.get(_PORT_ENV_VAR, _DEFAULT_PORT)
    user = os.environ.get(_USER_ENV_VAR, _DEFAULT_USER)
    password = os.environ.get(_PASSWORD_ENV_VAR, _DEFAULT_PASSWORD)
    database = os.environ.get(_DATABASE_ENV_VAR, _DEFAULT_DATABASE)

    with tempfile.NamedTemporaryFile(
        "w", delete=False, suffix=".sql", encoding="utf-8"
    ) as query_file:
        query_file.write(query)
        query_path = query_file.name

    with tempfile.NamedTemporaryFile(
        "w", delete=False, suffix=".py", encoding="utf-8"
    ) as script_file:
        script_file.write(
            _get_python_executor(
                server=server,
                port=port,
                user=user,
                password=password,
                database=database,
            )
        )
        script_path = script_file.name

    command = [
        "docker",
        "run",
        "--rm",
        "--network",
        network,
        "-v",
        f"{query_path}:/query.sql",
        "-v",
        f"{script_path}:/run_query.py",
        image,
        "python",
        "/run_query.py",
    ]

    print(f"\n=== {description} ===")
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=False)
    except FileNotFoundError as exc:
        print("STDERR: docker command not found. Is Docker installed and on PATH?")
        raise exc
    finally:
        for path in (query_path, script_path):
            try:
                os.remove(path)
            except OSError:
                pass

    if result.stdout:
        print(result.stdout, end="")

    if result.returncode != 0 and result.stderr:
        print("STDERR:", result.stderr)


__all__ = ["run_sql", "get_config"]
