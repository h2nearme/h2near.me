import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';



export default class extends Controller {
  static targets = ["map", "input", "result", "longitude", "latitude", "postalCode", "house"];

  connect() {
    mapboxgl.accessToken = this.element.dataset.key;
    if (this.longitudeTarget.value && this.latitudeTarget.value) {
      this.pinOnMap(this.longitudeTarget.value, this.latitudeTarget.value)
    }

    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
  });
  geocoder.addTo(this.inputTarget);
  geocoder.on('result', (event) => {
    const longitude = event.result.center[0] || null
    const latitude = event.result.center[1] || null
    this.longitudeTarget.value = longitude
    this.latitudeTarget.value = latitude
    this.postalCodeTarget.value = event.result.context.find(item => item.id.includes('postcode') )?.text || null
    this.houseTarget.value = event.result.address || null

    this.pinOnMap(longitude, latitude)
  });
  }

  pinOnMap(longitude, latitude) {
    if (this.map) {
      this.map.remove()
    }
    const map = new mapboxgl.Map({
      container: this.mapTarget,
      // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
      style: 'mapbox://styles/mapbox/outdoors-v12',
      center: [longitude, latitude],
      zoom: 14,
      attributionControl: false,
      });
      this.map = map

      new mapboxgl.Marker(this.createElement()).setLngLat([longitude, latitude]).addTo(map);
  }

  createElement() {
    const element = document.createElement('div');
    const width = 30;
    const height = 30;
    element.className = 'marker';
    element.style.backgroundImage = `url(${window.location.origin}/marker.svg)`;
    element.style.width = `${width}px`;
    element.style.height = `${height}px`;
    element.style.backgroundSize = '100%';
    return element
  }

  disconnect() {
    this.map.remove()
  }
}
