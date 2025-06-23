import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  markAsRead() {
    fetch("/notifications/mark_as_read", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
        "Content-Type": "application/json"
      }
    }).then(response => {
      if (response.ok) {
        const badge = document.querySelector("#notificationBadge")
        if (badge) badge.remove()
      }
    })
  }
}
