# SQL Mystery GitHub Page

A static frontend that lets you run SQL queries against your `sql/database.sql` directly in the browser.

## How It Works

- Uses [PyScript](https://pyscript.net/) to run Python in the browser.
- Uses Python's `sqlite3` module (inside Pyodide/WebAssembly).
- Loads `sql/database.sql` from the `sql` folder.
- Builds an in-memory SQLite database at runtime.
- Executes any SQL query you type in the editor.

## Files

- `index.html`: page structure and script imports.
- `style.css`: visual design and responsive layout.
- `app.py`: Python runtime logic, SQL loading, include resolution, query execution, and result rendering.
- `sql/database.sql`: main setup/orchestration SQL file.
- `sql/tables/*.sql`: one file per table (schema + seed data).

## SQL File Organization

Use `sql/database.sql` as your entry point and include table files with:

```sql
-- @include tables/suspects.sql
-- @include tables/clues.sql
-- @include tables/damage_logs.sql
```

The app resolves these includes in order before executing SQL, so you can keep each table in its own file while preserving a single setup flow.

## Python Project (uv)

This repository now uses `uv` with:

- `pyproject.toml`
- `uv.lock`

Install/sync the environment:

```bash
uv sync
```

Run linting:

```bash
uv run ruff check .
```

Dependency notes:

- Runtime dependencies in `pyproject.toml` are intentionally empty because the app runs in-browser via PyScript/Pyodide on GitHub Pages.
- A dev dependency (`ruff`) is included for local code quality checks.

## Use Locally

Because browsers block local `fetch` for some files, run a tiny static server:

```bash
python3 -m http.server 8000
```

Then open `http://localhost:8000`.

## Deploy to GitHub Pages

1. Push this repo to GitHub.
2. In repository settings, open **Pages**.
3. Under **Build and deployment**, set source to **Deploy from a branch**.
4. Choose branch `master` and folder `/ (root)`.
5. Save. After deploy, your site URL will be available there.

## Notes

- Any changes made by `INSERT/UPDATE/DELETE` are in-memory only and reset on refresh.
- Query execution is single-statement per run (for example one `SELECT` or one `UPDATE`).
