#!/usr/bin/env python3
"""Initialize SQL Server database."""

import os
import sys
import time

import pymssql

HOST = os.getenv("SQL_SERVER_HOST", "sqlserver")
PORT = int(os.getenv("SQL_SERVER_PORT", "1433"))
USER = "sa"
PASSWORD = os.getenv("MSSQL_SA_PASSWORD", "YourStrong@Passw0rd")


def wait_for_sql_server(max_attempts=30):
    """Wait for SQL Server to be ready."""
    print(f"Waiting for SQL Server at {HOST}:{PORT}...")
    for attempt in range(1, max_attempts + 1):
        try:
            conn = pymssql.connect(
                server=HOST, port=PORT, user=USER, password=PASSWORD, database="master"
            )
            conn.close()
            print(f"✓ SQL Server is ready!")
            return True
        except Exception as e:
            print(f"  Attempt {attempt}/{max_attempts}: {e}")
            time.sleep(2)
    return False


def execute_sql_file(filepath):
    """Execute SQL file."""
    print(f"\nReading: {filepath}")

    with open(filepath, "r", encoding="utf-8") as f:
        sql_content = f.read()

    # Split by GO
    batches = [batch.strip() for batch in sql_content.split("GO") if batch.strip()]
    print(f"Found {len(batches)} batches")

    try:
        conn = pymssql.connect(
            server=HOST,
            port=PORT,
            user=USER,
            password=PASSWORD,
            database="master",
            autocommit=True,
        )
        cursor = conn.cursor()

        for i, batch in enumerate(batches, 1):
            try:
                cursor.execute(batch)
                print(f"  Batch {i}/{len(batches)} ✓")
            except Exception as e:
                print(f"  Batch {i}/{len(batches)} ✗: {e}")

        cursor.close()
        conn.close()
        print("\n✓ Database initialized successfully!")
        return True
    except Exception as e:
        print(f"\n✗ Failed: {e}")
        return False


if __name__ == "__main__":
    if not wait_for_sql_server():
        print("✗ Could not connect to SQL Server")
        sys.exit(1)

    if execute_sql_file("/app/init/01-university-complete.sql"):
        sys.exit(0)
    else:
        sys.exit(1)
