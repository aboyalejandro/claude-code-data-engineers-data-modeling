"""
Shared configuration for seed scripts.
"""

import os

# S3 Configuration
S3_BUCKET = "s3://synthetic-data-lakehouse/marketing"

# Tables to seed (matching dbt sources.yml)
TABLES = [
    'campaigns_daily',
    'ad_creatives',
    'sessions',
    'attribution_touchpoints',
    'conversions',
    'metadata_snapshots'
]

# PostgreSQL base configuration
POSTGRES_CONFIG = {
    'host': os.environ.get('POSTGRES_HOST', 'postgresql'),
    'port': int(os.environ.get('POSTGRES_PORT', '5432')),
    'user': os.environ.get('POSTGRES_USER', 'postgres'),
    'password': os.environ.get('POSTGRES_PASSWORD', 'password'),
    'database': os.environ.get('POSTGRES_DB', 'postgres')
}
