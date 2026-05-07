"""
DBT Assessment Package Setup
Makes the assessment installable with: pip install .
"""
from setuptools import setup, find_packages

setup(
    name="dbt-assessment",
    version="1.0.0",
    description="DBT Hands-On Assessment Package",
    packages=find_packages(),
    install_requires=[
        "dbt-duckdb==1.7.3",
        "duckdb>=0.10.0",
        "rich>=13.0.0",
    ],
    python_requires=">=3.8",
)
