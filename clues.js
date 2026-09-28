const cluesImage = document.getElementById("clues-image");
const cluesTitle = document.getElementById("clues-title");
const cluesDescription = document.getElementById("clues-description");
const cluesCounter = document.getElementById("clues-counter");
const cluesStatus = document.getElementById("clues-status");
const prevClueBtn = document.getElementById("prev-clue");
const nextClueBtn = document.getElementById("next-clue");

let clues = [];
let currentIndex = 0;

function setCluesStatus(message, isError = false) {
  cluesStatus.textContent = message;
  cluesStatus.className = isError ? "clues-status error" : "clues-status";
}

function renderCurrentClue() {
  if (clues.length === 0) {
    cluesImage.removeAttribute("src");
    cluesImage.alt = "No clue image loaded.";
    cluesImage.classList.add("is-empty");
    cluesTitle.textContent = "No clues available";
    cluesDescription.textContent = "Add images to clues/ and list them in clues/manifest.json.";
    cluesCounter.textContent = "0 / 0";
    prevClueBtn.disabled = true;
    nextClueBtn.disabled = true;
    return;
  }

  const clue = clues[currentIndex];
  const cluePath = `clues/${clue.file}`;

  cluesImage.src = cluePath;
  cluesImage.alt = clue.title || clue.file;
  cluesImage.classList.remove("is-empty");
  cluesTitle.textContent = clue.title || clue.file;
  cluesDescription.textContent = clue.description || "";
  cluesCounter.textContent = `${currentIndex + 1} / ${clues.length}`;

  prevClueBtn.disabled = currentIndex === 0;
  nextClueBtn.disabled = currentIndex === clues.length - 1;
}

function showPreviousClue() {
  if (currentIndex === 0) {
    return;
  }

  currentIndex -= 1;
  renderCurrentClue();
}

function showNextClue() {
  if (currentIndex >= clues.length - 1) {
    return;
  }

  currentIndex += 1;
  renderCurrentClue();
}

async function loadClues() {
  try {
    setCluesStatus("Loading clues folder...");
    const response = await fetch(`clues/manifest.json?t=${Date.now()}`);

    if (!response.ok) {
      throw new Error(`Could not load clues/manifest.json (HTTP ${response.status}).`);
    }

    const payload = await response.json();
    if (!payload || !Array.isArray(payload.images)) {
      throw new Error("Invalid clues manifest format. Expected { images: [] }.");
    }

    clues = payload.images.filter((entry) => entry && typeof entry.file === "string");
    currentIndex = 0;
    renderCurrentClue();

    if (clues.length === 0) {
      setCluesStatus("No clue images listed yet. Add entries in clues/manifest.json.");
    } else {
      setCluesStatus("Clues loaded.");
    }
  } catch (error) {
    clues = [];
    currentIndex = 0;
    renderCurrentClue();
    setCluesStatus(error.message || "Failed to load clues.", true);
  }
}

prevClueBtn.addEventListener("click", showPreviousClue);
nextClueBtn.addEventListener("click", showNextClue);
document.addEventListener("keydown", (event) => {
  if (event.key === "ArrowLeft") {
    showPreviousClue();
  }
  if (event.key === "ArrowRight") {
    showNextClue();
  }
});

loadClues();
