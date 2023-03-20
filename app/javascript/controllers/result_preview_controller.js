import { Controller } from "@hotwired/stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "longitude", "latitude", "volume", "pressure", "purity" ]

  connect() {
    const inputs = [
      this.longitudeTarget,
      this.latitudeTarget,
      this.volumeTarget,
      this.pressureTarget,
      this.purityTarget
    ]
    inputs.forEach(input => {
      input.addEventListener('input', this.handleInput.bind(this))
    })
  }

  handleInput(event) {
    if (!document.querySelector('#ribbon')) {
      const map = document.querySelector('#map')
      map.insertAdjacentHTML('afterbegin', `
        <div id="ribbon" class="ribbon"></div>
    `)
    }
    if(this.allInputsHaveValue()) {
    Rails.ajax({
      type: "GET",
      url: `${this.element.dataset.url}/?longitude=${this.longitudeTarget.value}&latitude=${this.latitudeTarget.value}&volume=${this.volumeTarget.value}&pressure=${this.pressureTarget.value}&purity=${this.purityTarget.value}`,
      dataType: "json",
      success: (data) => {
        console.log(Number.parseInt(data['supplier_locations_count']) > 0)
        if(Number.parseInt(data['supplier_locations_count']) > 0) {
          document.querySelector('#ribbon').innerHTML = `
          <p>
            ${data['supplier_locations_count']} locations found for current requirements
            <small>Submit your location to view results</small>
          </p>
          `
        } else {
          document.querySelector('#ribbon').innerHTML = ''
        }
      },
      error: (data) => {
        console.log(data)
        document.querySelector('#ribbon').innerHTML = ''
      }
    });
    }
  }

  allInputsHaveValue() {
    const inputs = [
      this.longitudeTarget,
      this.latitudeTarget,
      this.volumeTarget,
      this.pressureTarget,
      this.purityTarget
    ]
    return inputs.map(input => {
      return input.value === '' ? false : true
    }).every(v => v === true);
  }
}
