import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Post controller connected")
  }

  disconnect() {
    console.log("Post controller disconnected")
  }
}