import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    document.addEventListener('keydown', this.handleKeyPress.bind(this))
  }

  disconnect() {
    document.removeEventListener('keydown', this.handleKeyPress.bind(this))
  }

  async handleKeyPress(event) {
    // Проверяем нажатие Ctrl+X
    if (event.ctrlKey && event.key === 'x') {
      event.preventDefault()

      if (confirm('Вы уверены, что хотите поставить пост в очередь на удаление? Он будет удален через неделю.')) {
        try {
          const response = await fetch(`/posts/${this.element.dataset.postId}`, {
            method: 'DELETE',
            headers: {
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
              'Accept': 'application/json'
            }
          })

          if (response.ok) {
            const data = await response.json()
            alert('Пост поставлен в очередь на удаление')
          } else {
            throw new Error('Ошибка при постановке в очередь')
          }
        } catch (error) {
          console.error('Ошибка:', error)
          alert('Произошла ошибка при постановке поста в очередь на удаление')
        }
      }
    }
  }
}