"""
Seed PostgreSQL database with marketing data from S3 using DuckDB.
Reads Parquet files from s3://synthetic-data-lakehouse/marketing/ and loads into local Postgres.
"""

import duckdb
import psycopg2
import sys
from config import S3_BUCKET, TABLES, POSTGRES_CONFIG


def create_schema():
    """Create marketing schema if it doesn't exist."""
    conn = psycopg2.connect(**POSTGRES_CONFIG)
    cur = conn.cursor()
    cur.execute("CREATE SCHEMA IF NOT EXISTS marketing;")
    conn.commit()
    cur.close()
    conn.close()
    print("✓ Marketing schema created/verified")


def seed_table(table_name):
    """Seed a single table from S3 to PostgreSQL using DuckDB."""
    print(f"\n{'='*60}")
    print(f"Seeding table: {table_name}")
    print(f"{'='*60}")

    # Connect to DuckDB (in-memory)
    duck = duckdb.connect(':memory:')

    # Install and load extensions
    duck.execute("INSTALL httpfs;")
    duck.execute("LOAD httpfs;")
    duck.execute("INSTALL postgres;")
    duck.execute("LOAD postgres;")
    print("  Extensions loaded (httpfs for S3, postgres for DB)")

    # Try reading from S3 with fallback patterns
    s3_path = f"{S3_BUCKET}/{table_name}/**/*.parquet"
    print(f"  Reading from: {s3_path}")

    try:
        duck.execute(f"CREATE TABLE temp_{table_name} AS SELECT * FROM read_parquet('{s3_path}');")
    except:
        # Try without subdirectory pattern
        s3_path = f"{S3_BUCKET}/{table_name}/*.parquet"
        print(f"  Trying alternate path: {s3_path}")
        duck.execute(f"CREATE TABLE temp_{table_name} AS SELECT * FROM read_parquet('{s3_path}');")

    # Get row count
    row_count = duck.execute(f"SELECT COUNT(*) FROM temp_{table_name}").fetchone()[0]
    print(f"  ✓ Loaded {row_count:,} rows from S3")

    if row_count == 0:
        print(f"  ⚠ WARNING: No data found for {table_name}")
        duck.close()
        return False

    # Build PostgreSQL connection string
    postgres_conn_string = (
        f"postgresql://{POSTGRES_CONFIG['user']}:{POSTGRES_CONFIG['password']}"
        f"@{POSTGRES_CONFIG['host']}:{POSTGRES_CONFIG['port']}/{POSTGRES_CONFIG['database']}"
    )

    # Attach PostgreSQL and create table
    duck.execute(f"ATTACH '{postgres_conn_string}' AS pg (TYPE POSTGRES);")
    duck.execute(f"DROP TABLE IF EXISTS pg.marketing.{table_name} CASCADE;")
    duck.execute(f"CREATE TABLE pg.marketing.{table_name} AS SELECT * FROM temp_{table_name};")

    # Verify
    pg_count = duck.execute(f"SELECT COUNT(*) FROM pg.marketing.{table_name}").fetchone()[0]
    print(f"  ✓ Verified {pg_count:,} rows in PostgreSQL")

    duck.close()
    print(f"✓ Successfully seeded {table_name}")
    return True


def main():
    """Main seeding process."""
    print("="*60)
    print("PostgreSQL Data Seeding from S3")
    print("="*60)
    print(f"Source: {S3_BUCKET}")
    print(f"Target: {POSTGRES_CONFIG['host']}:{POSTGRES_CONFIG['port']}/{POSTGRES_CONFIG['database']}")
    print(f"Schema: marketing")
    print(f"Tables: {len(TABLES)}")
    print("="*60)

    try:
        # Create marketing schema
        create_schema()

        # Seed each table
        success_count = 0
        failed_tables = []

        for table in TABLES:
            try:
                if seed_table(table):
                    success_count += 1
                else:
                    failed_tables.append(table)
            except Exception as e:
                print(f"✗ ERROR seeding {table}: {str(e)}")
                failed_tables.append(table)

        # Summary
        print("\n" + "="*60)
        print("SEEDING SUMMARY")
        print("="*60)
        print(f"✓ Successfully seeded: {success_count}/{len(TABLES)} tables")

        if failed_tables:
            print(f"✗ Failed tables: {', '.join(failed_tables)}")
            print("="*60)
            sys.exit(1)
        else:
            print("✓ All tables seeded successfully!")
            print("="*60)
            sys.exit(0)

    except Exception as e:
        print(f"\n✗ FATAL ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
