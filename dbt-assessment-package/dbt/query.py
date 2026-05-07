#!/usr/bin/env python3
"""
Simple DuckDB Query Runner with Rich Formatting
Usage: python query.py "SELECT * FROM production.product LIMIT 5"
       python query.py -f query.sql
"""
import sys
import duckdb
from rich.console import Console
from rich.table import Table

def run_query(sql):
    """Run SQL query and print results with Rich formatting"""
    console = Console()
    conn = duckdb.connect('adventureworks.duckdb')

    try:
        result = conn.execute(sql)

        # Get column names
        if result.description:
            columns = [desc[0] for desc in result.description]
            rows = result.fetchall()

            # Create Rich table with no_wrap to show full values
            table = Table(show_header=True, header_style="bold cyan", box=None)

            # Add columns with overflow="fold" to show full content
            for col in columns:
                table.add_column(col, style="yellow", no_wrap=False, overflow="fold")

            # Add rows
            for row in rows:
                table.add_row(*[str(val) if val is not None else "[null]" for val in row])

            # Print table
            console.print(table)
            console.print(f"\n[bold green]✓[/bold green] {len(rows)} row(s) returned")
        else:
            console.print("[bold green]✓[/bold green] Query executed successfully")
    except Exception as e:
        console.print(f"[bold red]✗ Error:[/bold red] {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    # Read from file if -f flag
    if sys.argv[1] == "-f" and len(sys.argv) > 2:
        with open(sys.argv[2], 'r') as f:
            sql = f.read()
    else:
        # Read from command line argument
        sql = sys.argv[1]

    run_query(sql)
