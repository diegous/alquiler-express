import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  alert(event) {
    debugger
    const result = confirm("Está seguro?")

    if (!result) {
      event.preventDefault()
    }
  }
}
