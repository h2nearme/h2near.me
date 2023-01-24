import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import Directions from '@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js';


export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    mapboxgl.accessToken = this.mapTarget.dataset.key;
    const map = new mapboxgl.Map({
    container: this.mapTarget,
    // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
    style: 'mapbox://styles/mapbox/outdoors-v12',
    center: JSON.parse(this.mapTarget.dataset.center),
    zoom: Number.parseInt(this.mapTarget.dataset.zoom),
    attributionControl: false,
    });
    this.map = map

    const locations = JSON.parse(this.mapTarget.dataset.locations)

    locations.forEach(location => {
      new mapboxgl.Marker(this.createElement()).setLngLat([location[0], location[1]]).addTo(map);
    })

    // TESTING

    const directions = new Directions({
      accessToken: mapboxgl.accessToken,
      profile: 'mapbox/walking',
    })

    map.addControl(directions,'top-left');
    
    map.on('load', () => {
      const origin = JSON.parse(this.mapTarget.dataset.center)
      const destination = JSON.parse(this.mapTarget.dataset.locations)[0]
      directions.setOrigin(origin);
      directions.setDestination(destination);
      console.log(directions)
    });

    // TESTING END
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
