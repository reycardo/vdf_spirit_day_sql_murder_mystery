# SQL Mystery GitHub Page

A static frontend that lets you run SQL queries against your `database.sql` directly in the browser.

## How It Works

- Uses [PyScript](https://pyscript.net/) to run Python in the browser.
- Uses Python's `sqlite3` module (inside Pyodide/WebAssembly).
- Loads `database.sql` from the repository root.
- Builds an in-memory SQLite database at runtime.
- Executes any SQL query you type in the editor.

## Files

- `index.html`: page structure and script imports.
- `style.css`: visual design and responsive layout.
- `app.py`: Python runtime logic, SQL loading, query execution, and result rendering.
- `database.sql`: your SQL script (create this file with your schema/data).

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
- You can also click **Load .sql file** to test another SQL script without changing the repo.
- Query execution is single-statement per run (for example one `SELECT` or one `UPDATE`).
