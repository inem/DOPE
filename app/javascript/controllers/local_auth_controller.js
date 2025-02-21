import { Controller } from "@hotwired/stimulus"
import { faker } from '@faker-js/faker'

export default class extends Controller {
  static targets = ["status", "content", "placeholder"]
  static values = {
    uuid: String,
    port: Number,
    path: String
  }

  connect() {
    this.contentTarget.style.display = "none"
    this.generatePlaceholder()
    this.checkLocalServer()
  }

  generatePlaceholder() {
    const structure = []

    // Генерируем реалистичную структуру поста
    structure.push(`<div class="blur-text" style="filter: blur(3px);">`)
    structure.push(this.generateSection('intro'))

    // 2-3 основных раздела
    const sectionsCount = 2 + Math.floor(Math.random() * 2)
    for(let i = 0; i < sectionsCount; i++) {
      structure.push(this.generateSection('main'))
    }

    structure.push(this.generateSection('conclusion'))

    // Добавляем уведомление о локальном приложении
    structure.push(`
      <div class="local-app-notice" style="filter: none !important;">
        <p>Этот пост доступен только при наличии локального приложения</p>
        <p>Установите приложение чтобы прочитать контент</p>
      </div>
    `)

    structure.push('</div>')

    this.placeholderTarget.innerHTML = structure.join("\n")
  }

  generateSection(type) {
    const section = []

    // Заголовок для основных разделов
    if (type === 'main') {
      section.push(`<h2>${faker.lorem.sentence(3)}</h2>`)
    }

    // Генерируем параграфы
    const paragraphsCount = {
      'intro': 1,
      'main': 2 + Math.floor(Math.random() * 2),
      'conclusion': 1
    }[type]

    for(let i = 0; i < paragraphsCount; i++) {
      section.push(`<p>${this.generateParagraph()}</p>`)
    }

    // Добавляем списки для основных разделов
    if (type === 'main' && Math.random() > 0.5) {
      section.push(this.generateList())
    }

    // Иногда добавляем код для основных разделов
    if (type === 'main' && Math.random() > 0.7) {
      section.push(this.generateCode())
    }

    return section.join("\n")
  }

  generateParagraph() {
    return faker.lorem.paragraph(2 + Math.floor(Math.random() * 3))
  }

  generateList() {
    const items = []
    const count = 3 + Math.floor(Math.random() * 3)

    items.push('<ul>')
    for(let i = 0; i < count; i++) {
      items.push(`  <li>${faker.lorem.sentence()}</li>`)
    }
    items.push('</ul>')

    return items.join("\n")
  }

  generateCode() {
    const code = []
    code.push('<pre><code>')
    code.push('function example() {')
    code.push('  const data = prepare()')
    code.push('  return process(data)')
    code.push('}')
    code.push('</code></pre>')
    return code.join("\n")
  }

  async checkLocalServer() {
    try {
      const response = await fetch(`http://127.0.0.1:${this.portValue}/ping`, {
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
    this.showPlaceholder()
  }

  async loadContent() {
    try {
      const response = await fetch(this.pathValue)
      if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`)
      const html = await response.text()
      this.contentTarget.innerHTML = html
      this.showContent()
    } catch (e) {
      console.error("Failed to load content:", e)
      this.showPlaceholder()
    }
  }

  showContent() {
    console.log("Showing content")
    this.contentTarget.style.display = ""  // Используем пустую строку вместо "block"
    this.placeholderTarget.style.display = "none"
  }

  showPlaceholder() {
    console.log("Showing placeholder")
    this.contentTarget.style.display = "none"
    this.placeholderTarget.style.display = ""  // Используем пустую строку вместо "block"
  }

  getPostAuthor() {
    // Получаем данные автора из data-атрибутов
    const userElement = document.querySelector("[data-user]")
    return userElement ? JSON.parse(userElement.dataset.user) : null
  }
}