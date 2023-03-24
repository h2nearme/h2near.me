import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleChange() {
    this.element.submit()
  }
}
