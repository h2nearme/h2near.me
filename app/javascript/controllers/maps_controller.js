import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    mapboxgl.accessToken = this.mapTarget.dataset.key;
    const map = new mapboxgl.Map({
    container: this.mapTarget,
    // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
    style: 'mapbox://styles/mapbox/outdoors-v12',
    center: [-6.599110, 54.607009],
    zoom: 8,
    attributionControl: false,
    });
    this.map = map
  }

  disconnect() {
    this.map.remove()
  }
}
