import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';



export default class extends Controller {
  static targets = ["map", "input", "result", "longitude", "latitude", "postalCode", "house"];

  connect() {
    mapboxgl.accessToken = this.element.dataset.key;

    const geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      localGeocoder: this.coordinatesGeocoder,
      enableGeolocation: true,
      reverseGeocode: true,
      mapboxgl: mapboxgl
    });

    this.geocoder = geocoder

    const map = new mapboxgl.Map({
      container: this.mapTarget,
      // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
      style: 'mapbox://styles/mapbox/outdoors-v12',
      center: [-6.599110, 54.607009],
      zoom: 8,
      attributionControl: false,
    });
    this.map = map
    if (this.longitudeTarget.value && this.latitudeTarget.value) {
      this.pinOnMap(this.longitudeTarget.value, this.latitudeTarget.value)
    }
    this.addGeocoder()
    this.addPointerSelection()
  }

  addPointerSelection() {
    this.map.on('click', (event) => {
      const query = Object.values(event.lngLat)
      const longitude = query[0]
      const latitude = query[1]
      this.longitudeTarget.value = longitude
      this.latitudeTarget.value = latitude
      this.pinOnMap(longitude, latitude)
      this.postalCodeTarget.value = null
      this.houseTarget.value = null
      const inputEvent = new Event('input', {
          bubbles: true,
          cancelable: true,
      });
        
      this.longitudeTarget.dispatchEvent(inputEvent);
      this.latitudeTarget.dispatchEvent(inputEvent);
    });
  }

  addGeocoder() {
    this.geocoder.addTo(this.inputTarget);
    this.geocoder.on('result', (event) => {
      const longitude = event.result.center[0] || null
      const latitude = event.result.center[1] || null
      this.longitudeTarget.value = longitude
      this.latitudeTarget.value = latitude
      this.postalCodeTarget.value = event.result?.context?.find(item => item.id.includes('postcode') )?.text || null
      this.houseTarget.value = event.result.address || null
  
      this.pinOnMap(longitude, latitude)
      const inputEvent = new Event('input', {
        bubbles: true,
        cancelable: true,
      });
        
      this.longitudeTarget.dispatchEvent(inputEvent);
      this.latitudeTarget.dispatchEvent(inputEvent);
    });
  }

  pinOnMap(longitude, latitude) {
    if (this.marker) {
      this.marker.remove()
    }

    const marker = new mapboxgl.Marker(this.createElement()).setLngLat([longitude, latitude]).addTo(this.map);
    this.marker = marker
    this.map.flyTo({
      center: [longitude, latitude],
      essential: true // this animation is considered essential with respect to prefers-reduced-motion
    });
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

  coordinatesGeocoder(query) {
    // Match anything which looks like
    // decimal degrees coordinate pair.
    const matches = query.match(
    /^[ ]*(?:Lat: )?(-?\d+\.?\d*)[, ]+(?:Lng: )?(-?\d+\.?\d*)[ ]*$/i
    );
    if (!matches) {
    return null;
    }
    function coordinateFeature(lng, lat) {
    return {
    center: [lng, lat],
    geometry: {
    type: 'Point',
    coordinates: [lng, lat]
    },
    place_name: 'Lat: ' + lat + ' Lng: ' + lng,
    place_type: ['coordinate'],
    properties: {},
    type: 'Feature'
    };
    }
     
    const coord1 = Number(matches[1]);
    const coord2 = Number(matches[2]);
    const geocodes = [];
     
    if (coord1 < -90 || coord1 > 90) {
    // must be lng, lat
    geocodes.push(coordinateFeature(coord1, coord2));
    }
     
    if (coord2 < -90 || coord2 > 90) {
    // must be lat, lng
    geocodes.push(coordinateFeature(coord2, coord1));
    }
     
    if (geocodes.length === 0) {
    // else could be either lng, lat or lat, lng
    geocodes.push(coordinateFeature(coord1, coord2));
    geocodes.push(coordinateFeature(coord2, coord1));
    }
     
    return geocodes;
  };
}
