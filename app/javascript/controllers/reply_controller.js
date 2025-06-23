import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    commentId: Number,
    commentEmail: String
  }

  show(event) {
    event.preventDefault()

    const commentId = event.target.dataset.commentIdValue
    const email = event.target.dataset.commentEmailValue

    const formContainer = document.getElementById("comment-reply-form")
    const parentField = formContainer.querySelector("#comment_parent_id")
    const replyEmail = document.getElementById("reply-email")

    parentField.value = commentId
    replyEmail.textContent = email

    const commentBox = event.target.closest(".mb-3")
    commentBox.after(formContainer)
    formContainer.classList.remove("d-none")
    formContainer.scrollIntoView({ behavior: "smooth", block: "center" })
  }
}
