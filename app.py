import asyncio
import html
import sqlite3
import time

from js import document
from pyodide.ffi import create_proxy
from pyodide.http import pyfetch

status_el = document.getElementById("status")
query_input = document.getElementById("query-input")
run_query_btn = document.getElementById("run-query")
load_default_btn = document.getElementById("load-default")
reset_db_btn = document.getElementById("reset-db")
file_input = document.getElementById("file-input")
results_meta_el = document.getElementById("results-meta")
results_wrap_el = document.getElementById("results-wrap")

conn = None
loaded_script = ""


def set_status(message: str, kind: str = "") -> None:
    status_el.textContent = message
    status_el.className = f"status {kind}".strip()


def create_db_from_sql(script_text: str) -> None:
    global conn, loaded_script

    if conn is not None:
        conn.close()

    conn = sqlite3.connect(":memory:")
    conn.executescript(script_text)
    loaded_script = script_text

    run_query_btn.disabled = False
    reset_db_btn.disabled = False
    set_status("Database loaded. You can run queries now.", "ok")


def render_table(columns: list[str], rows: list[tuple]) -> None:
    header_html = "".join(f"<th>{html.escape(col)}</th>" for col in columns)

    body_html = "".join(
        "<tr>"
        + "".join(
            f"<td>{html.escape('NULL' if cell is None else str(cell))}</td>"
            for cell in row
        )
        + "</tr>"
        for row in rows
    )

    results_wrap_el.innerHTML = (
        "<section class=\"result-set\">"
        "<h3>Result Set 1</h3>"
        "<table><thead><tr>"
        + header_html
        + "</tr></thead><tbody>"
        + body_html
        + "</tbody></table></section>"
    )


async def load_default_script() -> None:
    try:
        set_status("Loading database.sql...", "")
        # Cache-bust to always fetch latest script on refresh/deploy propagation.
        response = await pyfetch(f"database.sql?t={int(time.time())}")

        if not response.ok:
            raise RuntimeError(
                f"database.sql was not found (HTTP {response.status}). Add it to the repository root."
            )

        script_text = await response.string()
        create_db_from_sql(script_text)
    except Exception as exc:
        set_status(str(exc), "error")


async def handle_file_upload(event) -> None:
    try:
        files = event.target.files
        if files.length == 0:
            return

        sql_file = files[0]
        script_text = await sql_file.text()
        create_db_from_sql(str(script_text))
        set_status(f"Loaded SQL script from {sql_file.name}.", "ok")
    except Exception as exc:
        set_status(f"Failed to load SQL file: {exc}", "error")


def reset_db(_event=None) -> None:
    if not loaded_script:
        return

    try:
        create_db_from_sql(loaded_script)
        set_status("Database reset to initial loaded SQL script.", "ok")
        results_meta_el.textContent = "Database reset. Run a query."
        results_wrap_el.innerHTML = ""
    except Exception as exc:
        set_status(f"Could not reset database: {exc}", "error")


def run_query(_event=None) -> None:
    if conn is None:
        set_status("Load a database script first.", "error")
        return

    query = str(query_input.value).strip()
    if not query:
        set_status("Enter a query first.", "error")
        return

    try:
        started_at = time.perf_counter()
        cursor = conn.cursor()
        cursor.execute(query)

        elapsed_ms = max(1, round((time.perf_counter() - started_at) * 1000))

        if cursor.description:
            columns = [col[0] for col in cursor.description]
            rows = cursor.fetchall()
            render_table(columns, rows)
            results_meta_el.textContent = (
                f"Query executed in {elapsed_ms} ms. {len(rows)} row(s) returned."
            )
        else:
            conn.commit()
            changed = cursor.rowcount if cursor.rowcount != -1 else 0
            results_meta_el.textContent = (
                f"Query executed in {elapsed_ms} ms. No rows returned. Rows affected: {changed}."
            )
            results_wrap_el.innerHTML = ""

        set_status("Query completed successfully.", "ok")
    except Exception as exc:
        set_status(f"Query failed: {exc}", "error")


def on_load_default_click(_event=None) -> None:
    asyncio.create_task(load_default_script())


def on_file_change(event) -> None:
    asyncio.create_task(handle_file_upload(event))


load_default_proxy = create_proxy(on_load_default_click)
run_query_proxy = create_proxy(run_query)
reset_db_proxy = create_proxy(reset_db)
file_change_proxy = create_proxy(on_file_change)

load_default_btn.disabled = False
load_default_btn.addEventListener("click", load_default_proxy)
run_query_btn.addEventListener("click", run_query_proxy)
reset_db_btn.addEventListener("click", reset_db_proxy)
file_input.addEventListener("change", file_change_proxy)

set_status("Python runtime is ready. Load a database script to begin.", "ok")
