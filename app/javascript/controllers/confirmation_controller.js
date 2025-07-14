import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { message: String }

  alert(event) {
    debugger
    const message = this.messageValue || "Está seguro?"
    const result = confirm(message)

    if (!result) {
      event.preventDefault()
    }
  }
}
