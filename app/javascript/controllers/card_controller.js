import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cardNumber"];

  initialize() {
    this.format()
  }

  format() {
    // Remove non-digits
    let value = this.cardNumberTarget.value.replace(/\D/g, "");

    // Limit to 16 digits
    value = value.substring(0, 16);

    // Add a space every 4 digits
    const formatted = value.match(/.{1,4}/g)?.join("  ") || "";

    this.cardNumberTarget.value = formatted;
  }
}
