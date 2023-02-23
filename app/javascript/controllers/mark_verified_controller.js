import Rails from "@rails/ujs";

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleClick(event) {
    const choice = confirm("Are you sure you wish to change the state of this record?");
    if (!choice) return;
    Rails.ajax({
      type: "POST",
      url: event.currentTarget.dataset.url,
      dataType: "json",
      success: (data) => {
        if (data['supplier_location']['verified']) {
          this.element.classList.remove('btn-warning')
          this.element.classList.add('btn-success')
          this.element.classList.add('active')
          this.element.ariaLabel = "This location is verified"
        } else {
          this.element.classList.remove('btn-success')
          this.element.classList.remove('active')
          this.element.classList.add('btn-warning')
          this.element.ariaLabel = "This location is not verified"
        }
      },
      error: (data) => {
        console.log(data)
      }
    });
  }
}
