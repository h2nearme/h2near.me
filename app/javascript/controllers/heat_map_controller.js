import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static targets = ["map"];

  connect() {
    mapboxgl.accessToken = this.mapTarget.dataset.key;
    const map = new mapboxgl.Map({
      container: this.mapTarget,
      style: 'mapbox://styles/mapbox/light-v11',
      center: JSON.parse(this.mapTarget.dataset.center),
      zoom: this.mapTarget.dataset.zoom
    });
    this.map = map
    this.setupLayers()
  }

  setupLayers() {
    this.map.on('load', () => {
      this.map.addSource('offtaker_locations', {
        type: 'geojson',
        data: JSON.parse(this.mapTarget.dataset.locations)
      });
      this.setupHeatmap()
      this.setupCircleLayer()
      this.setupPopupLayer()
    });
  }

  setupHeatmap() {
    this.map.addLayer(
      {
        id: 'offtaker-locations-heat',
        type: 'heatmap',
        source: 'offtaker_locations',
        maxzoom: 13,
        paint: {
          // increase weight as diameter breast height increases
          'heatmap-weight': {
            property: 'volume',
            type: 'exponential',
            stops: [
              [1, 0],
              [62, 1]
            ]
          },
          // increase intensity as zoom level increases
          'heatmap-intensity': {
            stops: [
              [9, 1],
              [12, 3]
            ]
          },
          // assign color values be applied to points depending on their density
          'heatmap-color': [
            'interpolate',
            ['linear'],
            ['heatmap-density'],
            0,
            'rgba(255,243,59, 0)',
            0.2,
            'rgb(253,199,12)',
            0.4,
            'rgb(243,144,63)',
            0.6,
            'rgb(237,104,60)',
            0.8,
            'rgb(233,62,58)'
          ],
          // increase radius as zoom increases
          'heatmap-radius': {
            stops: [
              [9, 50],
              [12, 60]
            ]
          },
          // decrease opacity to transition into the circle layer
          'heatmap-opacity': {
            default: 1,
            stops: [
              [14, 1],
              [15, 0]
            ]
          }
        }
      },
      'waterway-label'
    )
  }

  setupCircleLayer() {
    this.map.addLayer(
      {
        id: 'offtaker-locations-point',
        type: 'circle',
        source: 'offtaker_locations',
        minzoom: 12,
        paint: {
          // increase the radius of the circle as the zoom level and volume value increases
          'circle-radius': {
            property: 'volume',
            type: 'exponential',
            stops: [
              [{ zoom: 15, value: 1 }, 5],
              [{ zoom: 15, value: 62 }, 10],
              [{ zoom: 22, value: 1 }, 20],
              [{ zoom: 22, value: 62 }, 50]
            ]
          },
          'circle-color': {
            property: 'volume',
            type: 'exponential',
            stops: [
              [0, 'rgb(255,243,59)'],
              [20, 'rgb(253,199,12)'],
              [40, 'rgb(243,144,63)'],
              [60, 'rgb(237,104,60)'],
              [80, 'rgb(233,62,58)']
            ]
          },
          'circle-stroke-color': 'white',
          'circle-stroke-width': 1,
          'circle-opacity': {
            stops: [
              [14, 0],
              [15, 1]
            ]
          }
        }
      },
      'waterway-label'
    );
  }

  setupPopupLayer() {
    this.map.on('click', 'offtaker-locations-point', (event) => {
      new mapboxgl.Popup()
        .setLngLat(event.features[0].geometry.coordinates)
        .setHTML(`
          <a href="/offtakers/offtaker_locations/${event.features[0].properties.id}" target="_blank">
            <h4>${event.features[0].properties.name}</h4>
            <strong>Volume:</strong> ${event.features[0].properties.volume}
          </a>
        `)
        .addTo(this.map);
    });
  }
}
