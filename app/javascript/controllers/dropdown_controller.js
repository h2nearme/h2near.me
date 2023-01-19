import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  handleExpand(event) {
    if(event.type === 'closeBubble') {
      this.menuTarget.classList.add("collapsed");
    } else {
      this.menuTarget.classList.toggle("collapsed");
    }
  }
}
