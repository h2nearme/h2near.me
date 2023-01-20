import { Controller } from "@hotwired/stimulus"
import * as bootstrap from 'bootstrap'

export default class extends Controller {
  handleClick(event) {
    event.preventDefault()
    const target = event.currentTarget.dataset.target
    const tab = document.querySelector(target)
    const bootstrapTab = new bootstrap.Tab(tab)
    bootstrapTab.show()
  }
}