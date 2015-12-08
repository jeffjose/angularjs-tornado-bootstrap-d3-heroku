"use strict"

app.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise('404')

#######################################################
#
#                  Landing/Home
#
#######################################################

  landing =
    name: 'landing'
    url: ''
    templateUrl: 'static/partials/sampleapp.html'
    controller: 'SampleAppCtrl'

  $stateProvider.state(landing)

  return
