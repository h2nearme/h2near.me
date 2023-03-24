import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "display", "config" ]

  handleScopeChange(event) {
    Object.assign(this, event.currentTarget.dataset)
    this.displayTarget.innerHTML = this.title
    this.configTarget.dataset.url = this.url
    this.configTarget.dataset.variant = this.variant
    const dropdownEvent = new CustomEvent("closeBubble")
    const reloadChartEvent = new CustomEvent("reloadChart")
    window.dispatchEvent(dropdownEvent)
    window.dispatchEvent(reloadChartEvent)
  }
}
