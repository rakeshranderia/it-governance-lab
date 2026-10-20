import os

import psycopg


def required_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"Required environment variable is missing: {name}")
    return value


def main():
    connection = psycopg.connect(
        host=required_env("PGHOST"),
        port=required_env("PGPORT"),
        dbname=required_env("PGDATABASE"),
        user=required_env("PGUSER"),
        password=required_env("PGPASSWORD"),
    )

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT current_database(), current_user, version()")
            database_name, user_name, version = cursor.fetchone()

            print("Connected successfully")
            print("Database:", database_name)
            print("User:", user_name)
            print("PostgreSQL:", version)

            cursor.execute(
                "SELECT id, name, type, status, purchase_price "
                "FROM assets ORDER BY id"
            )
            rows = cursor.fetchall()

            print()
            print("Assets in PostgreSQL:")
            for row in rows:
                print(row)
    finally:
        connection.close()


if __name__ == "__main__":
    main()
