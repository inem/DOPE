import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]

  connect() {
    this.checkLocalServer()
  }

  async checkLocalServer() {
    const user = this.getPostAuthor()
    if (!user || !user.local_port) return

    try {
      const response = await fetch(`http://127.0.0.1:${user.local_port}/ping`, {
        headers: { "Accept": "application/json" }
      })

      if (response.ok) {
        const data = await response.json()
        if (data.uuid === user.uuid) {
          // Автор поста найден локально
          this.statusTarget.textContent = "✓ Local"
          this.statusTarget.classList.add("local")
        }
      }
    } catch (e) {
      console.log("Local server not available:", e)
    }
  }

  getPostAuthor() {
    // Получаем данные автора из data-атрибутов
    const userElement = document.querySelector("[data-user]")
    return userElement ? JSON.parse(userElement.dataset.user) : null
  }
}