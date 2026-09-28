const themeLightBtn = document.getElementById("theme-light");
const themeDarkBtn = document.getElementById("theme-dark");

const THEME_STORAGE_KEY = "sqlMysteryTheme";

function getActiveTheme() {
  return document.documentElement.dataset.theme === "dark" ? "dark" : "light";
}

function updateToggleUI() {
  const isDark = getActiveTheme() === "dark";
  themeLightBtn.setAttribute("aria-pressed", String(!isDark));
  themeDarkBtn.setAttribute("aria-pressed", String(isDark));
}

function setTheme(theme) {
  document.documentElement.dataset.theme = theme;
  localStorage.setItem(THEME_STORAGE_KEY, theme);
  updateToggleUI();
}

themeLightBtn.addEventListener("click", () => setTheme("light"));
themeDarkBtn.addEventListener("click", () => setTheme("dark"));

const systemThemeQuery = window.matchMedia
  ? window.matchMedia("(prefers-color-scheme: dark)")
  : null;

if (systemThemeQuery) {
  systemThemeQuery.addEventListener("change", (event) => {
    if (!localStorage.getItem(THEME_STORAGE_KEY)) {
      document.documentElement.dataset.theme = event.matches ? "dark" : "light";
      updateToggleUI();
    }
  });
}

updateToggleUI();
