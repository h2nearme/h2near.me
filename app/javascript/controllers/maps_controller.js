import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import Directions from '@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js';
import Rails from "@rails/ujs";


export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    this.offtakerLocationId = this.mapTarget.dataset.offtakerLocationId
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

    new mapboxgl.Marker()
    .setLngLat(JSON.parse(this.mapTarget.dataset.center))
    .addTo(map);

    const locations = JSON.parse(this.mapTarget.dataset.locations)

    const directions = new Directions({
      accessToken: mapboxgl.accessToken,
      profile: 'mapbox/walking',
    })

    this.map.addControl(directions,'top-left');
    this.directions = directions
    locations.forEach(location => {
      const markerElement = this.createElement() 

      if (this.mapTarget.dataset.routing) {

        const name = location[2];
        const content = `
          <div class="popup-content">
            <h4>
              ${name} 
            </h4> 
          </div>
          `;
        
        const wrapper = document.createElement('div');
        const button = document.createElement('div');
        button.innerHTML = `<button class="btn btn-primary" data-location="${JSON.stringify([location[0], location[1]])}" data-destination-id="${location[3]}">Calculate</button>`;
        wrapper.innerHTML = content;
        wrapper.appendChild(button);
        button.querySelector('button').addEventListener('click', this.createRoute.bind(this));
        
        const popup = new mapboxgl.Popup({
            offset: 25
          })
          .setDOMContent(wrapper);

          new mapboxgl.Marker(markerElement)
          .setLngLat([location[0], location[1]])
          .setPopup(popup) 
          .addTo(map);
      } else {
        new mapboxgl.Marker(markerElement)
        .setLngLat([location[0], location[1]])
        .addTo(map);
      }
    })

  }

  createRoute(event) {
    event.preventDefault()
    const routingResults = document.querySelector('#routing-results')
    const supplierLocationId = event.currentTarget.dataset.destinationId
    const offtakerLocationId = this.offtakerLocationId

    this.directions.on("route", event => {
      const routes = event.route
      const distance = Math.round(routes[0].distance / 100) / 10
      routingResults.innerHTML = `
        <div>
          <p id="distance">
            ${distance}km
          </p>
        </div>
      
      `
      Rails.ajax({
        type: "POST",
        url: `${window.location.origin}/scenarios`,
        data: `scenario[distance]=${distance}&scenario[supplier_location_id]=${supplierLocationId}&scenario[offtaker_location_id]=${offtakerLocationId}`,
        dataType: "json",
        success: (data) => {
          console.log(data)
        },
        error: (data) => {
          console.log(data)
        }
      });
    })

    const origin = JSON.parse(this.mapTarget.dataset.center)
    const destination = JSON.parse(event.currentTarget.dataset.location)
    this.directions.setOrigin(origin);
    this.directions.setDestination(destination);
    
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

  drawRoute(event) {
    event.preventDefault()

    const origin = JSON.parse(this.mapTarget.dataset.center)
    const destination = JSON.parse(event.currentTarget.dataset.location)
    this.directions.setOrigin(origin);
    this.directions.setDestination(destination);
  }

  disconnect() {
    this.map.remove()
  }
}
