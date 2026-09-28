const openTutorialBtn = document.getElementById("open-tutorial");
const closeTutorialBtn = document.getElementById("close-tutorial");
const closeTutorialFooterBtn = document.getElementById("close-tutorial-footer");
const tutorialOverlay = document.getElementById("tutorial-overlay");

const TUTORIAL_SEEN_STORAGE_KEY = "sqlMysteryTutorialSeen";

function openTutorial() {
  tutorialOverlay.hidden = false;
  document.body.classList.add("tutorial-open");
}

function closeTutorial() {
  tutorialOverlay.hidden = true;
  document.body.classList.remove("tutorial-open");
  localStorage.setItem(TUTORIAL_SEEN_STORAGE_KEY, "true");
}

openTutorialBtn.addEventListener("click", openTutorial);
closeTutorialBtn.addEventListener("click", closeTutorial);
closeTutorialFooterBtn.addEventListener("click", closeTutorial);
tutorialOverlay.addEventListener("click", (event) => {
  if (event.target === tutorialOverlay) {
    closeTutorial();
  }
});
document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && !tutorialOverlay.hidden) {
    closeTutorial();
  }
});

if (!localStorage.getItem(TUTORIAL_SEEN_STORAGE_KEY)) {
  openTutorial();
}
