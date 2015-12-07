"use strict"

module = angular.module("sampleApp", ["ngRoute"])

module.config ($routeProvider) ->

  $routeProvider.when("/",
    title: "Sample Application"
    templateUrl: "static/partials/sampleapp.html"

  ).when("/link1",
    title: "Link1 | Sample Application"
    templateUrl: "static/partials/link1.html"

  ).otherwise templateUrl: "static/partials/404.html"

  return
