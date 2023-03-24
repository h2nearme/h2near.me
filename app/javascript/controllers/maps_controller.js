import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import Directions from '@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js';
import Rails from "@rails/ujs";
import * as bootstrap from 'bootstrap'


export default class extends Controller {
  static targets = [ "map" ]

  connect() {
    this.originLocationId = ([this.mapTarget.dataset.originLocationId, window.location.pathname.includes('suppliers') ? 'supplier' : 'offtaker'])
    mapboxgl.accessToken = this.mapTarget.dataset.key;
    const map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/outdoors-v12',
      center: JSON.parse(this.mapTarget.dataset.center),
      zoom: Number.parseInt(this.mapTarget.dataset.zoom),
      attributionControl: false,
    });
    this.map = map
    new mapboxgl.Marker().setLngLat(JSON.parse(this.mapTarget.dataset.center)).addTo(map);

    const locations = JSON.parse(this.mapTarget.dataset.locations)

    locations.forEach(location => {
      const markerElement = this.createElement() 
      
      if (this.mapTarget.dataset.routing) {
        new mapboxgl.Marker()
        .setLngLat(JSON.parse(this.mapTarget.dataset.center))
        .addTo(map);

        const popup = this.createPopup(location)

        new mapboxgl.Marker(markerElement)
          .setLngLat([location[0], location[1]])
          .setPopup(popup) 
          .addTo(map);
      } else {
        map.scrollZoom.disable();
        new mapboxgl.Marker(markerElement)
        .setLngLat([location[0], location[1]])
        .addTo(map);
      }
    })

  }

  createPopup(location) {
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
    button.innerHTML = `<button class="btn btn-primary" data-location="${JSON.stringify([location[0], location[1]])}" data-destination-id="${location[3]}" id="location-${location[3]}">Calculate</button>`;
    wrapper.innerHTML = content;
    wrapper.appendChild(button);
    button.querySelector('button').addEventListener('click', this.createRoute.bind(this));
    
    const popup = new mapboxgl.Popup({
        offset: 25
      })
      .setDOMContent(wrapper);
    return popup
  }

  createRoute(event) {
    event.preventDefault()
    const location = event.currentTarget.dataset.location;
    const destinationId = event.currentTarget.dataset.destinationId;
    const button = event.currentTarget
    const data = {destinationId, location, button}
    this.setDirections()
    data.button.innerHTML = `<i class="fa-solid fa-spinner fa-spin"></i>`;
    this.directions.on("route", (event) => this.storeRouteData(event, data)) 

    this.directions.setOrigin(JSON.parse(this.mapTarget.dataset.center));
    this.directions.setDestination(JSON.parse(location));
  }

  storeRouteData(event, data) {
    const routingResults = document.querySelector('#routing-results')
    const destinationLocationId = data.destinationId
    const originLocationId = this.originLocationId
    const button = data.button

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
      data: `scenario[distance]=${distance}&scenario[${originLocationId[1] === 'supplier' ? 'offtaker' : 'supplier'}_location_id]=${destinationLocationId}&scenario[${originLocationId[1]}_location_id]=${originLocationId[0]}`,
      dataType: "text/vnd.turbo-stream.html",
      success: (data) => {
        const scenariosList = document.querySelector('#scenarios');
        scenariosList.insertAdjacentHTML('beforeend', data['scenario_html'])
        const listItem = document.querySelector(`#scenario_${data['scenario']['id']}`)
        document.querySelectorAll('#scenarios li').forEach(scenario => {
          scenario.classList.remove('active')
        })
        listItem.classList.add('active')
        this.showLocationsTab()
        button.innerHTML = "Success"
        location.assign(data['scenario_url']);
      },
      error: (data) => {
        console.log(data)
      }
    });
  }

  setDirections() {
    const directions = new Directions({
      accessToken: mapboxgl.accessToken,
      profile: `mapbox/driving`,
    })
    this.directions = directions
    this.map.addControl(directions,'top-left');  
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

  showLocationsTab() {
    const tab = document.querySelector('#locations-tab')
    const bootstrapTab = new bootstrap.Tab(tab)
    bootstrapTab.show()
  }

  drawRoute(event) {
    event.preventDefault()
    this.setDirections()

    const origin = JSON.parse(this.mapTarget.dataset.center)
    const destination = JSON.parse(event.currentTarget.dataset.location)
    this.directions.setOrigin(origin);
    this.directions.setDestination(destination);
    const popup = this.createPopup(destination)
    const markerElement = this.createElement() 

    new mapboxgl.Marker(markerElement)
      .setLngLat([destination[0], destination[1]])
      .setPopup(popup) 
      .addTo(this.map)
      .togglePopup();

  }

  disconnect() {
    this.map.remove()
  }
}
