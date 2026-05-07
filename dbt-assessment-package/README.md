# DBT Hands-On Assessment

## Prerequisites

- Python 3.8+
- VS Code (or any code editor)

---

## Installation Instructions

### Step 1: Extract the Package

```bash
# Extract the ZIP file to a directory
# Example: Extract to ~/Documents/assessment/
unzip dbt-assessment-package.zip

# After extraction, your directory should look like this:
# assessment/
# ├── README.md
# ├── setup.py
# ├── requirements.txt
# ├── DBT Hands-On Assessment.md
# ├── WINDOWS-SETUP-FIX.md
# └── dbt/
#     ├── query.py
#     ├── profiles.yml
#     ├── seeds/
#     └── ...
```

### Step 2: Install Dependencies

**IMPORTANT:** Run these commands from the directory containing `setup.py` (NOT from inside `dbt/`)

```bash
# Navigate to the extracted directory
cd ~/Documents/assessment/  # Or wherever you extracted

# Verify you're in the right place - you should see setup.py
ls setup.py  # Should output: setup.py

# Create virtual environment
python3 -m venv .venv

# Activate virtual environment
source .venv/bin/activate  # macOS/Linux
# Windows: .venv\Scripts\activate

# Verify you're using the venv Python
which python
# Should show: .../assessment/.venv/bin/python

# Install all dependencies (this may take 1-2 minutes)
pip install .

# Verify dbt is installed correctly
which dbt
# Should show: .../assessment/.venv/bin/dbt (NOT a global install!)

dbt --version
# Should show: dbt-core 1.7.19 with duckdb plugin
```

### Step 3: Initialize DBT Project

```bash
# Navigate to the dbt directory
cd dbt

# Install dbt packages (dbt_utils, codegen)
dbt deps --profiles-dir .

# Load seed data into DuckDB database
dbt seed --profiles-dir .

# Verify setup is correct
dbt debug --profiles-dir .
# Should show: "All checks passed!"

# Verify database was created
ls -lh adventureworks.duckdb
# Should show: ~6MB database file
```

**Note:** The `--profiles-dir .` flag tells dbt to use the `profiles.yml` in the current directory.

---

## Working on the Assessment

### Read the Tasks

```bash
# From the dbt/ directory
cat "../DBT Hands-On Assessment.md"
```

### Essential DBT Commands

**IMPORTANT:** Run these from the `dbt/` directory

```bash
dbt run --profiles-dir .          # Run models
dbt snapshot --profiles-dir .     # Run snapshots
dbt test --profiles-dir .         # Run tests
```

### Running SQL Queries (Task 5)

**IMPORTANT:** Run these from the `dbt/` directory

```bash
# Use the query helper script
python query.py "SELECT * FROM production.product LIMIT 5"

# Or run from a SQL file
python query.py -f task5_solution.sql

# Example: Test the starter queries
python query.py "SELECT COUNT(*) FROM production.sales_order_header"
```

**Example Output (with Rich formatting):**

```bash
$ python query.py "SELECT product_id, name, list_price FROM production.product WHERE list_price > 0 LIMIT 5"

 product_id   name                          list_price
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 680          HL Road Frame - Black, 58     1431.500
 706          HL Road Frame - Red, 58       1431.500
 707          Sport-100 Helmet, Red         34.990
 708          Sport-100 Helmet, Black       34.990
 709          Mountain Bike Socks, M        9.500

✓ 5 row(s) returned
```

**Note:** All values are displayed in full - no truncation of long numbers or text.

---

## Troubleshooting

### Windows: "ModuleNotFoundError: No module named 'rpds.rpds'"

If you see this error when running `dbt --version`:

**Solution 1: Reinstall rpds-py (Quick Fix)**
```powershell
# Make sure venv is activated
.venv\Scripts\activate

# Reinstall rpds-py with pre-built wheels
pip uninstall rpds-py -y
pip install rpds-py --force-reinstall --no-cache-dir

# Test dbt
dbt --version
```

**Solution 2: Clean Reinstall (If Solution 1 doesn't work)**
```powershell
# Deactivate and remove venv
deactivate
Remove-Item -Recurse -Force .venv

# Upgrade pip first (IMPORTANT for Windows!)
python -m pip install --upgrade pip

# Create fresh venv
python -m venv .venv
.venv\Scripts\activate

# Upgrade pip inside venv
python -m pip install --upgrade pip

# Install dependencies
pip install .

# Test
dbt --version
```

**Root Cause:** Windows needs pre-built binary wheels for `rpds-py`. Older pip versions may not find the correct wheel.

---

### Windows Users: C++ Build Tools Error

If you see `Microsoft Visual C++ 14.0 or greater is required`:

**Option 1: Use pre-built wheels**
```powershell
pip install --only-binary :all: duckdb==0.10.0
pip install dbt-duckdb==1.7.3
```

**Option 2: Use older stable version**
```powershell
pip install duckdb==0.9.2 dbt-duckdb==1.6.2
```

**Option 3: Install Build Tools (6GB, one-time)**
- Download: https://visualstudio.microsoft.com/visual-cpp-build-tools/
- Install "Desktop development with C++"

See `WINDOWS-SETUP-FIX.md` for detailed instructions.

### Error: "dbt-fusion" or "unknown variant `duckdb`"

This means you have another dbt installation interfering. Solution:

```bash
# Make sure you're using the venv dbt
which dbt
# Should show: .venv/bin/dbt

# If it shows a different path, deactivate and reactivate:
deactivate
source .venv/bin/activate
which dbt  # Check again
```


## Quick Reference

### Directory Structure
```
assessment/
├── .venv/              # Virtual environment (created by you)
├── setup.py            # Installation config
├── README.md           # This file
├── DBT Hands-On Assessment.md  # Tasks
└── dbt/
    ├── adventureworks.duckdb   # Database (created after dbt seed)
    ├── query.py                # SQL helper script
    ├── profiles.yml            # DuckDB connection
    ├── dbt_project.yml         # DBT config
    ├── seeds/                  # Source CSV data
    ├── models/                 # Your models go here
    ├── snapshots/              # Your snapshots go here
    └── tests/                  # Your tests go here
```

### Where to Run Commands

| Command | Run From | Directory |
|---------|----------|-----------|
| `pip install .` | Parent directory | `assessment/` |
| `dbt deps/seed/run/test` | dbt directory | `assessment/dbt/` |
| `python query.py` | dbt directory | `assessment/dbt/` |

---

Good luck! 
