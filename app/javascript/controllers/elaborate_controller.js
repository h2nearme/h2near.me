import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"];

  handleInput(event) {
    const explanations = {
      'Standard': `
        <strong>Standard from electrolysis (∼98% / 1 nine)</strong>
        <br><br>
        Internal combustion engines for transportation; Residential/commercial combustion appliances (e.g. boilers, cookers, and similar applications)
      `,
      'ITMs': `
        <strong>Electrolysis using ion transport membranes (99.8% / 2 nines)</strong>
        <br><br>
        Industrial fuel for power generation and heat generation except PEM fuel cell applications`,
      'Pure': `
        <strong>Pure hydrogen (hydrogen purity ≥ 99.99% / 4 nines)</strong>
        <br><br>
        PEM fuel cell for road vehicles
      `,
      'High pure': `
        <strong>High pure hydrogen (hydrogen purity ≥ 99.999% / 5 nines)</strong>
        <br><br>
        Aircraft and space-vehicle ground support systems except PEM fuel cell applications
      `,
      'Ultrapure': `
        <strong>Ultrapure hydrogen (hydrogen purity ≥ 99.9999% / 6 nines)</strong>
        <br><br>
        Aircraft and space-vehicle on-board propulsion and electrical energy requirements; off-road vehicles
      `,
    }
    this.displayTarget.innerHTML = explanations[event.currentTarget.value]
    this.displayTarget.classList.remove('d-none')
  }
}
