const LEADERBOARD_URL = "https://script.google.com/macros/s/AKfycbyBEXxPZpGjp4hhafCswwl7OFLus0rx0YcuCJxYZVuKSBaT6K8quq3N9RmpdCta66WA/exec";
const EVENT_START = new Date("2026-10-13T15:00:00");
const REFRESH_INTERVAL_MS = 60000;
const MY_TEAM_STORAGE_KEY = "sqlMysteryMyTeam";
const SOLVED_STORAGE_KEY = "sqlMysterySolved";

const leaderboardStatusEl = document.getElementById("leaderboard-status");
const leaderboardListEl = document.getElementById("leaderboard-list");
const leaderboardClaimEl = document.getElementById("leaderboard-claim");
const teamNameInput = document.getElementById("team-name-input");
const claimSpotBtn = document.getElementById("claim-spot");
const accuseResultEl = document.getElementById("accuse-result");

let myTeam = localStorage.getItem(MY_TEAM_STORAGE_KEY) || "";
let solved = localStorage.getItem(SOLVED_STORAGE_KEY) === "1";

function isConfigured() {
  return LEADERBOARD_URL.startsWith("https://") && !LEADERBOARD_URL.includes("PASTE_YOUR_APPS_SCRIPT");
}

function boardOpen() {
  return Date.now() >= EVENT_START.getTime();
}

function escapeHtml(value) {
  return String(value).replace(
    /[&<>"']/g,
    (char) =>
      ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;",
      })[char],
  );
}

function formatClock(timestamp) {
  const date = new Date(timestamp);
  if (Number.isNaN(date.getTime())) {
    return "";
  }
  return date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", second: "2-digit" });
}

function formatElapsed(seconds) {
  if (typeof seconds !== "number" || !Number.isFinite(seconds) || seconds < 0) {
    return "";
  }
  const total = Math.round(seconds);
  const hours = Math.floor(total / 3600);
  const minutes = Math.floor((total % 3600) / 60);
  const secs = total % 60;
  if (hours > 0) {
    return `${hours}h ${String(minutes).padStart(2, "0")}m`;
  }
  if (minutes > 0) {
    return `${minutes}m ${String(secs).padStart(2, "0")}s`;
  }
  return `${secs}s`;
}

function setLeaderboardStatus(message, isError = false) {
  leaderboardStatusEl.textContent = message;
  leaderboardStatusEl.className = isError ? "leaderboard-status error" : "leaderboard-status";
}

function renderBoard(entries) {
  if (!entries.length) {
    leaderboardListEl.innerHTML = "";
    return;
  }

  leaderboardListEl.innerHTML = entries
    .map((entry, index) => {
      const rank = index + 1;
      const medal = rank === 1 ? "🥇" : rank === 2 ? "🥈" : rank === 3 ? "🥉" : `${rank}.`;
      const isMine = myTeam && String(entry.team).toLowerCase() === myTeam.toLowerCase();
      const elapsed = formatElapsed(entry.elapsedSeconds);
      return (
        `<li class="leaderboard-entry${isMine ? " is-mine" : ""}">` +
        `<span class="leaderboard-rank">${medal}</span>` +
        `<span class="leaderboard-team">${escapeHtml(entry.team)}</span>` +
        `<span class="leaderboard-time">${formatClock(entry.timestamp)}` +
        (elapsed ? `<small>+${elapsed}</small>` : "") +
        "</span></li>"
      );
    })
    .join("");
}

function fetchJsonp(url) {
  return new Promise((resolve, reject) => {
    const callbackName = `mysteryBoardCallback${Date.now()}${Math.floor(Math.random() * 1000)}`;
    const script = document.createElement("script");
    const timeout = setTimeout(() => {
      cleanup();
      reject(new Error("Timed out"));
    }, 12000);

    function cleanup() {
      clearTimeout(timeout);
      delete window[callbackName];
      script.remove();
    }

    window[callbackName] = (data) => {
      cleanup();
      resolve(data);
    };
    script.onerror = () => {
      cleanup();
      reject(new Error("Network error"));
    };
    script.src = `${url}${url.includes("?") ? "&" : "?"}callback=${callbackName}`;
    document.head.appendChild(script);
  });
}

async function fetchBoard() {
  if (!isConfigured()) {
    setLeaderboardStatus("The Winners' Board is being set up - check back soon.");
    updateClaimVisibility();
    return;
  }

  if (!boardOpen()) {
    leaderboardListEl.innerHTML = "";
    setLeaderboardStatus("The Winners' Board opens at kickoff on 13 Oct, 15:00.");
    updateClaimVisibility();
    return;
  }

  setLeaderboardStatus("Loading winners...");
  try {
    let data;
    try {
      const response = await fetch(`${LEADERBOARD_URL}?action=list`, { cache: "no-store" });
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }
      data = await response.json();
    } catch (directError) {
      data = await fetchJsonp(`${LEADERBOARD_URL}?action=list`);
    }

    if (!data || data.ok !== true) {
      throw new Error((data && data.error) || "Unexpected response");
    }

    const entries = Array.isArray(data.entries) ? data.entries : [];
    renderBoard(entries);
    setLeaderboardStatus(
      entries.length
        ? `${entries.length} team(s) on the board.`
        : "No team has cracked the case yet - be the first!",
    );
  } catch (error) {
    setLeaderboardStatus(
      "Could not reach the Winners' Board. Post your team name in the Teams chat so the organiser can log it.",
      true,
    );
  }
  updateClaimVisibility();
}

async function claimSpot() {
  const team = teamNameInput.value.trim();
  if (!team) {
    setLeaderboardStatus("Enter your team name before claiming your spot.", true);
    return;
  }

  claimSpotBtn.disabled = true;
  setLeaderboardStatus("Claiming your spot...");

  try {
    let data = null;
    try {
      const response = await fetch(LEADERBOARD_URL, {
        method: "POST",
        headers: { "Content-Type": "text/plain;charset=utf-8" },
        body: JSON.stringify({ action: "claim", team }),
      });
      try {
        data = await response.json();
      } catch (parseError) {
        data = null;
      }
    } catch (directError) {
      data = null;
    }

    if (data && data.ok === true) {
      myTeam = data.entry && data.entry.team ? data.entry.team : team;
      localStorage.setItem(MY_TEAM_STORAGE_KEY, myTeam);
      teamNameInput.value = "";
      if (Array.isArray(data.entries)) {
        renderBoard(data.entries);
      }
      setLeaderboardStatus(
        data.already
          ? `Already on the board as ${myTeam}.`
          : `You're on the board as ${myTeam}!`,
      );
    } else if (data && data.error) {
      setLeaderboardStatus(data.error, true);
    } else {
      await sendClaimWithoutResponse(team);
    }
  } catch (error) {
    await sendClaimWithoutResponse(team);
  } finally {
    claimSpotBtn.disabled = false;
    setTimeout(fetchBoard, 1200);
  }
}

async function sendClaimWithoutResponse(team) {
  try {
    await fetch(LEADERBOARD_URL, {
      method: "POST",
      mode: "no-cors",
      headers: { "Content-Type": "text/plain;charset=utf-8" },
      body: JSON.stringify({ action: "claim", team }),
    });
    myTeam = team;
    localStorage.setItem(MY_TEAM_STORAGE_KEY, myTeam);
    teamNameInput.value = "";
    setLeaderboardStatus("Claim sent. The board will update in a moment.");
  } catch (error) {
    setLeaderboardStatus(
      "Could not claim your spot. Post your team name in the Teams chat so the organiser can log it.",
      true,
    );
  }
}

function updateClaimVisibility() {
  leaderboardClaimEl.hidden = !(solved && boardOpen() && isConfigured());
}

function handleSolved() {
  solved = true;
  localStorage.setItem(SOLVED_STORAGE_KEY, "1");
  updateClaimVisibility();
  if (!boardOpen()) {
    setLeaderboardStatus("Case closed! The Winners' Board opens at kickoff on 13 Oct, 15:00.");
  } else if (isConfigured()) {
    setLeaderboardStatus("Case closed! Claim your team's spot on the Winners' Board.");
    leaderboardClaimEl.scrollIntoView({ behavior: "smooth", block: "center" });
  }
}

const accuseObserver = new MutationObserver(() => {
  if (accuseResultEl.classList.contains("correct")) {
    handleSolved();
  }
});
accuseObserver.observe(accuseResultEl, { attributes: true, attributeFilter: ["class"] });

claimSpotBtn.addEventListener("click", claimSpot);
teamNameInput.addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    claimSpot();
  }
});
document.addEventListener("visibilitychange", () => {
  if (!document.hidden) {
    fetchBoard();
  }
});

if (solved) {
  updateClaimVisibility();
}
fetchBoard();
setInterval(fetchBoard, REFRESH_INTERVAL_MS);
