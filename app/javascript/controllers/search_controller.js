import Rails from "@rails/ujs";

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list"];

  handleInput(event) {
    const url = `${this.inputTarget.dataset.url}/?q=${event.currentTarget.value}`
    console.log(url)
    Rails.ajax({
      type: "GET",
      url: url,
      dataType: "json",
      success: (data) => {
        this.listTarget.innerHTML = data.locations
      },
      error: (data) => {
        console.log(data)
      }
    });
  }
}
