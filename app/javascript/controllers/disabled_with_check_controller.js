import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "wrapper", "button" ];

  handleInput(event) {
    if (event.currentTarget.checked) {
      this.buttonTarget.disabled = false
      this.wrapperTarget.removeAttribute('data-balloon-pos')
    } else {
      this.wrapperTarget.setAttribute('data-balloon-pos', 'up-left')
      this.buttonTarget.disabled = true
    }
  }

}
