import Rails from "@rails/ujs";

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleClick(event) {
    Rails.ajax({
      type: "POST",
      url: event.currentTarget.dataset.url,
      dataType: "json",
      success: (data) => {
        if (data['scenario']['favourite']) {
          this.element.classList.add('active')
        } else {
          this.element.classList.remove('active')
        }
      },
      error: (data) => {
        console.log(data)
      }
    });
  }
}
