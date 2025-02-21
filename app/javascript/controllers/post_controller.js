import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Post controller connected")
    document.addEventListener('keydown', this.handleKeyPress.bind(this))
  }

  disconnect() {
    console.log("Post controller disconnected")
    document.removeEventListener('keydown', this.handleKeyPress.bind(this))
  }

  async handleDelete(event) {
    event.preventDefault()
    console.log("Delete action triggered")

    // Добавляем визуальный эффект
    this.element.style.opacity = "0.5"
    this.element.style.transition = "opacity 0.2s ease"

    try {
      console.log("Sending DELETE request for post", this.element.dataset.postId)
      const response = await fetch(`/posts/${this.element.dataset.postId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      })

      if (response.ok) {
        const data = await response.json()
        console.log("Success response:", data)

        // Создаем элемент для обратного отсчета
        const countdown = document.createElement('div')
        countdown.style.position = 'fixed'
        countdown.style.top = '50%'
        countdown.style.left = '50%'
        countdown.style.transform = 'translate(-50%, -50%)'
        countdown.style.fontSize = '48px'
        countdown.style.color = '#e74c3c'
        document.body.appendChild(countdown)

        // Запускаем обратный отсчет
        let seconds = 3
        const timer = setInterval(() => {
          countdown.textContent = seconds
          if (seconds <= 0) {
            clearInterval(timer)
            window.location.href = '/'
          }
          seconds--
        }, 1000)
      } else {
        throw new Error('Ошибка при постановке в очередь')
      }
    } catch (error) {
      console.error('Ошибка:', error)
      this.element.style.opacity = "1"
      alert('Произошла ошибка при постановке поста в очередь на удаление')
    }
  }

  handleKeyPress(event) {
    if (event.ctrlKey && event.key === 'x') {
      event.preventDefault()
      this.handleDelete(event)
    }
  }

  async handleRestore(event) {
    event.preventDefault()
    console.log("Restore triggered")

    try {
      const response = await fetch(`/posts/${this.element.dataset.postId}/restore`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      })

      if (response.ok) {
        const data = await response.json()
        console.log("Success response:", data)
        window.location.reload()
      } else {
        throw new Error('Ошибка при восстановлении')
      }
    } catch (error) {
      console.error('Ошибка:', error)
      alert('Произошла ошибка при восстановлении поста')
    }
  }
}