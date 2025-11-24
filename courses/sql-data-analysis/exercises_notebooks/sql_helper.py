"""Shared SQL helper utilities for the SQL exercise notebooks.

The `run_sql` function executes a SQL statement inside the existing
`sql-data-analysis-init-db` Docker image and prints tabular results.
Configuration is driven by environment variables (loaded from the nearest
`.env` file) so notebooks can be portable across machines.
"""

from __future__ import annotations

import os
import subprocess
import tempfile
from pathlib import Path
from textwrap import dedent
from typing import Dict

_DEFAULT_NETWORK = "sql-data-analysis_db_network_uek"
_NETWORK_ENV_VAR = "SQL_DOCKER_NETWORK"
_IMAGE_ENV_VAR = "SQL_DOCKER_IMAGE"
_DEFAULT_IMAGE = "sql-data-analysis-init-db"
_ENV_FILENAME = ".env"
_ENV_LOADED = False

_PYTHON_EXECUTOR = dedent(
    """
    import pymssql
    import sys

    try:
        conn = pymssql.connect(
            server='sqlserver',
            port=1433,
            user='sa',
            password='YourStrong@Passw0rd',
            database='university'
        )
        cursor = conn.cursor()

        with open('/query.sql', 'r', encoding='utf-8') as f:
            sql = f.read()

        cursor.execute(sql)

        columns = [desc[0] for desc in cursor.description] if cursor.description else []
        rows = cursor.fetchall()

        if columns:
            print(" | ".join(str(col) for col in columns))
            print("-" * (sum(len(str(col)) for col in columns) + len(columns) * 3 - 1))

        if rows:
            for row in rows:
                print(" | ".join(str(val) if val is not None else "NULL" for val in row))
            print(f"\\n({len(rows)} row(s) returned)")
        else:
            print("(0 rows returned)")

        cursor.close()
        conn.close()

    except Exception as exc:  # pragma: no cover - surfaced in notebook output
        print(f"Error: {exc}", file=sys.stderr)
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
    """Return the effective helper configuration."""
    _load_first_env_file()
    return {
        "docker_network": os.environ.get(_NETWORK_ENV_VAR, _DEFAULT_NETWORK),
        "docker_image": os.environ.get(_IMAGE_ENV_VAR, _DEFAULT_IMAGE),
    }


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

    with tempfile.NamedTemporaryFile(
        "w", delete=False, suffix=".sql", encoding="utf-8"
    ) as query_file:
        query_file.write(query)
        query_path = query_file.name

    with tempfile.NamedTemporaryFile(
        "w", delete=False, suffix=".py", encoding="utf-8"
    ) as script_file:
        script_file.write(_PYTHON_EXECUTOR)
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
