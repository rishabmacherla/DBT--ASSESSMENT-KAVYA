# Windows Setup Fix - DuckDB C++ Build Tools Error

## The Problem

Windows users see this error:
```
error: Microsoft Visual C++ 14.0 or greater is required
Failed to build duckdb
```

## Solution: Use Pre-Built Wheels

We'll update the installation to use pre-built DuckDB binaries (no compilation needed).

## Fixed Installation Methods

### Method 1: Updated setup.py (Recommended)

The new setup.py automatically handles this. Just run:
```bash
python setup.py
```

### Method 2: Manual Installation (If setup.py fails)

```bash
# Step 1: Create virtual environment
python -m venv .venv

# Step 2: Activate it
.venv\Scripts\activate

# Step 3: Upgrade pip first (IMPORTANT!)
python -m pip install --upgrade pip

# Step 4: Install with pre-built wheels
pip install --only-binary :all: duckdb==0.10.0
pip install dbt-duckdb==1.7.3

# Step 5: Setup dbt
cd dbt
dbt deps
dbt seed
```

### Method 3: Alternative Python Package (If still failing)

Use an older, more stable version:
```bash
pip install duckdb==0.9.2
pip install dbt-duckdb==1.6.2
```

## Testing the Fix

To verify it works:
```bash
cd dbt
dbt debug
# Should show: "All checks passed!"
```

## If Nothing Works

Install Visual Studio Build Tools (one-time, 6GB download):
https://visualstudio.microsoft.com/visual-cpp-build-tools/

Then rerun setup.py

---

**Note:** The updated setup.py (v1.1) handles this automatically!
