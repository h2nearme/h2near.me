import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import Directions from '@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js';


export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    mapboxgl.accessToken = this.mapTarget.dataset.key;
    const map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/outdoors-v12',
      center: JSON.parse(this.mapTarget.dataset.center),
      zoom: Number.parseInt(this.mapTarget.dataset.zoom),
      attributionControl: false,
    });
    this.map = map
    const origin = JSON.parse(this.mapTarget.dataset.origin)
    const destination = JSON.parse(this.mapTarget.dataset.destination)

    const markerElement = this.createElement() 
    
      new mapboxgl.Marker()
      .setLngLat(JSON.parse(this.mapTarget.dataset.center))
      .addTo(map);

      const name = destination[2];
      const content = `
        <div class="popup-content">
          <h4>
            ${name} 
          </h4> 
        </div>
        `;
      
      const wrapper = document.createElement('div');
      wrapper.innerHTML = content;
      
      const popup = new mapboxgl.Popup({
          offset: 25
        })
        .setDOMContent(wrapper);

        new mapboxgl.Marker(markerElement)
        .setLngLat([destination[0], destination[1]])
        .setPopup(popup) 
        .addTo(map)
        .togglePopup();

        const directions = new Directions({
          accessToken: mapboxgl.accessToken,
          profile: 'mapbox/walking',
          interactive: false
        })
        console.log(directions)
        setTimeout(() => {
          this.directions = directions
        
          this.map.addControl(directions,'top-left');
          this.directions.setOrigin([origin[0], origin[1]]);
          this.directions.setDestination([destination[0], destination[1]]);
        }, 1000)


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
