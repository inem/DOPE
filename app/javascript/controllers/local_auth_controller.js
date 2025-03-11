import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "content", "placeholder"]
  static values = {
    uuid: String,
    port: Number,
    path: String
  }

  connect() {
    this.checkLocalServer()
  }

  async checkLocalServer() {
    try {
      const response = await fetch(`http://localhost:${this.portValue}/ping`, {
        headers: { "Accept": "application/json" }
      })

      if (response.ok) {
        const data = await response.json()
        if (data.uuid === this.uuidValue) {
          this.statusTarget.textContent = "Local"
          this.statusTarget.classList.add("local")
          await this.loadContent()
          return
        }
      }
    } catch (e) {
      console.error("Error checking local server:", e)
    }

    this.statusTarget.textContent = "Remote"
  }

  async loadContent() {
    try {
      const response = await fetch(this.pathValue)
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const html = await response.text()
      this.contentTarget.innerHTML = html
      this.contentTarget.style.display = ""
      this.placeholderTarget.style.display = "none"
    } catch (e) {
      console.error("Failed to load content:", e)
    }
  }

  getPostAuthor() {
    // Получаем данные автора из data-атрибутов
    const userElement = document.querySelector("[data-user]")
    return userElement ? JSON.parse(userElement.dataset.user) : null
  }
}