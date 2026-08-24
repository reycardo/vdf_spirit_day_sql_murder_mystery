import asyncio
import html
import json
import sqlite3
import time

from js import document, localStorage
from pyodide.ffi import create_proxy
from pyodide.http import pyfetch

status_el = document.getElementById("status")
query_input = document.getElementById("query-input")
run_query_btn = document.getElementById("run-query")
list_tables_btn = document.getElementById("list-tables")
load_default_btn = document.getElementById("load-default")
reset_db_btn = document.getElementById("reset-db")
file_input = document.getElementById("file-input")
results_meta_el = document.getElementById("results-meta")
results_wrap_el = document.getElementById("results-wrap")
saved_query_name_input = document.getElementById("saved-query-name")
save_query_btn = document.getElementById("save-query")
saved_queries_select = document.getElementById("saved-queries-select")
load_saved_query_btn = document.getElementById("load-saved-query")
delete_saved_query_btn = document.getElementById("delete-saved-query")

conn = None
loaded_script = ""
DEFAULT_SQL_PATH = "sql/database.sql"
INCLUDE_PREFIX = "-- @include"
SAVED_QUERIES_STORAGE_KEY = "sqlMysterySavedQueries"


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
    list_tables_btn.disabled = False
    reset_db_btn.disabled = False
    set_status("Database loaded. You can run queries now.", "ok")


def normalize_sql_path(path: str) -> str:
    parts = []
    for chunk in path.replace("\\", "/").split("/"):
        if chunk in ("", "."):
            continue
        if chunk == "..":
            if parts:
                parts.pop()
            continue
        parts.append(chunk)
    return "/".join(parts)


def resolve_include_path(parent_path: str, include_path: str) -> str:
    if include_path.startswith("/"):
        return normalize_sql_path(include_path)

    if "/" not in parent_path:
        return normalize_sql_path(include_path)

    base_dir = parent_path.rsplit("/", 1)[0]
    return normalize_sql_path(f"{base_dir}/{include_path}")


async def fetch_sql_file(sql_path: str) -> str:
    response = await pyfetch(f"{sql_path}?t={int(time.time())}")

    if not response.ok:
        raise RuntimeError(
            f"{sql_path} was not found (HTTP {response.status}). Check your SQL file structure."
        )

    return str(await response.string())


async def load_sql_with_includes(entry_path: str) -> str:
    async def expand(sql_path: str, include_stack: set[str]) -> str:
        if sql_path in include_stack:
            chain = " -> ".join(list(include_stack) + [sql_path])
            raise RuntimeError(f"Circular SQL include detected: {chain}")

        include_stack.add(sql_path)
        source = await fetch_sql_file(sql_path)
        expanded_lines = []

        for line in source.splitlines():
            stripped = line.strip()
            if stripped.startswith(INCLUDE_PREFIX):
                child_include_path = stripped[len(INCLUDE_PREFIX) :].strip()
                if not child_include_path:
                    continue

                child_sql_path = resolve_include_path(sql_path, child_include_path)
                expanded_lines.append(f"-- begin include {child_sql_path}")
                expanded_lines.append(await expand(child_sql_path, include_stack))
                expanded_lines.append(f"-- end include {child_sql_path}")
                continue

            expanded_lines.append(line)

        include_stack.remove(sql_path)
        return "\n".join(expanded_lines)

    return await expand(entry_path, set())


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
        set_status(f"Loading {DEFAULT_SQL_PATH}...", "")
        script_text = await load_sql_with_includes(DEFAULT_SQL_PATH)
        create_db_from_sql(script_text)
    except Exception as exc:  # noqa: BLE001
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
    except Exception as exc:  # noqa: BLE001
        set_status(f"Failed to load SQL file: {exc}", "error")


def reset_db(_event=None) -> None:
    if not loaded_script:
        return

    try:
        create_db_from_sql(loaded_script)
        set_status("Database reset to initial loaded SQL script.", "ok")
        results_meta_el.textContent = "Database reset. Run a query."
        results_wrap_el.innerHTML = ""
    except Exception as exc:  # noqa: BLE001
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
    except Exception as exc:  # noqa: BLE001
        set_status(f"Query failed: {exc}", "error")


def list_tables(_event=None) -> None:
    if conn is None:
        set_status("Load a database script first.", "error")
        return

    try:
        started_at = time.perf_counter()
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT name
            FROM sqlite_master
            WHERE type='table' AND name NOT LIKE 'sqlite_%'
            ORDER BY name;
            """
        )

        rows = cursor.fetchall()
        elapsed_ms = max(1, round((time.perf_counter() - started_at) * 1000))
        render_table(["table_name"], rows)
        results_meta_el.textContent = (
            f"Table list fetched in {elapsed_ms} ms. {len(rows)} table(s) found."
        )
        set_status("Table list loaded.", "ok")
    except Exception as exc:  # noqa: BLE001
        set_status(f"Could not list tables: {exc}", "error")


def on_load_default_click(_event=None) -> None:
    asyncio.create_task(load_default_script())


def on_file_change(event) -> None:
    asyncio.create_task(handle_file_upload(event))


def load_saved_queries() -> dict:
    raw = localStorage.getItem(SAVED_QUERIES_STORAGE_KEY)
    if not raw:
        return {}
    try:
        return json.loads(raw)
    except ValueError:
        return {}


def persist_saved_queries(saved_queries: dict) -> None:
    localStorage.setItem(SAVED_QUERIES_STORAGE_KEY, json.dumps(saved_queries))


def refresh_saved_queries_select(selected_name: str = "") -> None:
    saved_queries = load_saved_queries()

    options_html = '<option value="">Saved queries...</option>' + "".join(
        f'<option value="{html.escape(name)}">{html.escape(name)}</option>'
        for name in sorted(saved_queries)
    )
    saved_queries_select.innerHTML = options_html
    saved_queries_select.value = selected_name

    has_selection = bool(saved_queries_select.value)
    load_saved_query_btn.disabled = not has_selection
    delete_saved_query_btn.disabled = not has_selection


def save_query(_event=None) -> None:
    name = str(saved_query_name_input.value).strip()
    query = str(query_input.value).strip()

    if not name:
        set_status("Enter a name to save this query.", "error")
        return
    if not query:
        set_status("Write a query before saving it.", "error")
        return

    saved_queries = load_saved_queries()
    saved_queries[name] = query
    persist_saved_queries(saved_queries)
    refresh_saved_queries_select(name)
    set_status(f"Saved query '{name}'.", "ok")


def load_saved_query(_event=None) -> None:
    name = str(saved_queries_select.value)
    if not name:
        return

    saved_queries = load_saved_queries()
    query = saved_queries.get(name)
    if query is None:
        set_status(f"Saved query '{name}' not found.", "error")
        return

    query_input.value = query
    saved_query_name_input.value = name
    set_status(f"Loaded saved query '{name}'.", "ok")


def delete_saved_query(_event=None) -> None:
    name = str(saved_queries_select.value)
    if not name:
        return

    saved_queries = load_saved_queries()
    saved_queries.pop(name, None)
    persist_saved_queries(saved_queries)
    refresh_saved_queries_select()
    set_status(f"Deleted saved query '{name}'.", "ok")


async def bootstrap() -> None:
    try:
        load_default_btn.disabled = True
        list_tables_btn.disabled = True

        load_default_btn.addEventListener("click", load_default_proxy)
        list_tables_btn.addEventListener("click", list_tables_proxy)
        run_query_btn.addEventListener("click", run_query_proxy)
        reset_db_btn.addEventListener("click", reset_db_proxy)
        file_input.addEventListener("change", file_change_proxy)
        save_query_btn.addEventListener("click", save_query_proxy)
        load_saved_query_btn.addEventListener("click", load_saved_query_proxy)
        delete_saved_query_btn.addEventListener("click", delete_saved_query_proxy)
        saved_queries_select.addEventListener("change", saved_queries_select_change_proxy)

        refresh_saved_queries_select()

        load_default_btn.disabled = False
        set_status("Python runtime is ready. Load a database script to begin.", "ok")
    except Exception as exc:  # noqa: BLE001
        set_status(f"Startup failed: {exc}", "error")


def on_saved_queries_select_change(_event=None) -> None:
    has_selection = bool(saved_queries_select.value)
    load_saved_query_btn.disabled = not has_selection
    delete_saved_query_btn.disabled = not has_selection


load_default_proxy = create_proxy(on_load_default_click)
list_tables_proxy = create_proxy(list_tables)
run_query_proxy = create_proxy(run_query)
reset_db_proxy = create_proxy(reset_db)
file_change_proxy = create_proxy(on_file_change)
save_query_proxy = create_proxy(save_query)
load_saved_query_proxy = create_proxy(load_saved_query)
delete_saved_query_proxy = create_proxy(delete_saved_query)
saved_queries_select_change_proxy = create_proxy(on_saved_queries_select_change)

asyncio.create_task(bootstrap())
