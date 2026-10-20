import os

import psycopg
from psycopg.rows import dict_row


def required_env(name: str) -> str:
    value = os.getenv(name)

    if not value:
        raise RuntimeError(f"Required environment variable is missing: {name}")

    return value


def get_connection():
    return psycopg.connect(
        host=required_env("PGHOST"),
        port=required_env("PGPORT"),
        dbname=required_env("PGDATABASE"),
        user=required_env("PGUSER"),
        password=required_env("PGPASSWORD"),
        row_factory=dict_row,
    )
