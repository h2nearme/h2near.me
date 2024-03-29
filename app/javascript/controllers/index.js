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

import MarkFavouriteController from "./mark_favourite_controller"
application.register("mark-favourite", MarkFavouriteController)

import RouteController from "./route_controller"
application.register("route", RouteController)

import SearchController from "./search_controller"
application.register("search", SearchController)

import DisabledWithCheckController from "./disabled_with_check_controller"
application.register("disabled-with-check", DisabledWithCheckController)

import MarkVerifiedController from "./mark_verified_controller"
application.register("mark-verified", MarkVerifiedController)

import HeatMapController from "./heat_map_controller"
application.register("heat-map", HeatMapController)

import ElaborateController from "./elaborate_controller"
application.register("elaborate", ElaborateController)

import WavesController from "./waves_controller"
application.register("waves", WavesController)

import ResultPreviewController from "./result_preview_controller"
application.register("result-preview", ResultPreviewController)

import ChartScopeToggleController from "./chart_scope_toggle_controller.js"
application.register("chart-scope-toggle", ChartScopeToggleController)

import ChartsController from "./charts_controller.js"
application.register("charts", ChartsController)

import CheckboxController from "./checkbox_controller"
application.register("checkbox", CheckboxController)
