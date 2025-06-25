import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  start(event) {
    const button = event.target
    button.disabled = true
    button.innerHTML = `
      <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
      Connecting...
    `
  }
}
