// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import DropdownController from "./dropdown_controller.js"
application.register("dropdown", DropdownController)

import MapsController from "./maps_controller.js"
application.register("maps", MapsController)

import GeocoderController from "./geocoder_controller"
application.register("geocoder", GeocoderController)

import TabsController from "./tabs_controller"
application.register("tabs", TabsController)
