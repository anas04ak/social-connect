import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "dropdown"]

  connect() {
    this.mentions = []
    this.activeIndex = -1
  }

  async search() {
    const text = this.textareaTarget.value
    const atIndex = text.lastIndexOf("@")

    if (atIndex === -1) {
      this.hideDropdown()
      return
    }

    const query = text.slice(atIndex + 1)
    if (query.length < 1) {
      this.hideDropdown()
      return
    }

    const response = await fetch(`/users/mentionable?query=${query}`)
    this.mentions = await response.json()

    if (this.mentions.length === 0) {
      this.hideDropdown()
      return
    }

    this.showDropdown(this.mentions)
  }

  showDropdown(users) {
    this.dropdownTarget.innerHTML = users.map((user, index) =>
      `<div class="mention-item ${index === this.activeIndex ? 'active' : ''}" data-index="${index}">@${user.username}</div>`
    ).join("")

    this.dropdownTarget.classList.remove("d-none")
  }

  hideDropdown() {
    this.dropdownTarget.innerHTML = ""
    this.dropdownTarget.classList.add("d-none")
    this.activeIndex = -1
  }

  navigate(event) {
    if (this.dropdownTarget.classList.contains("d-none")) return

    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.activeIndex = (this.activeIndex + 1) % this.mentions.length
      this.showDropdown(this.mentions)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.activeIndex = (this.activeIndex - 1 + this.mentions.length) % this.mentions.length
      this.showDropdown(this.mentions)
    } else if (event.key === "Enter") {
      event.preventDefault()
      if (this.activeIndex >= 0) {
        this.selectMention(this.activeIndex)
      }
    }
  }

  selectMention(indexOrEvent) {
    const index = typeof indexOrEvent === "number"
      ? indexOrEvent
      : parseInt(indexOrEvent.target.dataset.index)

    const mention = this.mentions[index]
    const textarea = this.textareaTarget
    const text = textarea.value
    const atIndex = text.lastIndexOf("@")
    const newText = text.slice(0, atIndex) + `@${mention.username} `

    textarea.value = newText
    textarea.focus()
    this.hideDropdown()
  }
}
