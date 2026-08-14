import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ru", "en", "button"]

  connect() {
    this.setLanguage(localStorage.getItem("ruby-queen-language") || "en")
  }

  switch(event) {
    this.setLanguage(event.currentTarget.dataset.language)
  }

  setLanguage(language) {
    const russian = language === "ru"
    this.ruTargets.forEach((element) => element.hidden = !russian)
    this.enTargets.forEach((element) => element.hidden = russian)
    this.buttonTargets.forEach((button) => {
      button.classList.toggle("active", button.dataset.language === language)
      button.setAttribute("aria-pressed", button.dataset.language === language)
    })
    document.documentElement.lang = language
    localStorage.setItem("ruby-queen-language", language)
  }
}
