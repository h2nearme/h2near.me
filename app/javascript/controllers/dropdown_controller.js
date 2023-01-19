import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  handleExpand(event) {
    if(event.type === 'closeBubble') {
      this.menuTarget.classList.add("collapsed");
    } else {
      this.menuTarget.classList.toggle("collapsed");
      document.body.addEventListener('click', this.setupDropdownCollapse)
    }
  }

  setupDropdownCollapse(event) {
    if(event.target.closest('.bubble-dropdown-wrapper')) return;
    document.querySelectorAll('.bubble-dropdown').forEach(dropdown => {
      dropdown.classList.add('collapsed')
    })
    document.body.removeEventListener('click', this.setupDropdownCollapse)
  }

  close() {
    this.menuTarget.classList.add("collapsed");
  }
}
