"use strict"

app.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise('404')

#######################################################
#
#                  Landing/Home
#
#######################################################

  home =
    name: 'home'
    url: ''
    templateUrl: 'static/partials/home.html'
    controller: 'SampleAppCtrl'

  about =
    name: 'about'
    url: '/about'
    templateUrl: 'static/partials/about.html'
    controller: 'SampleAppCtrl'


  $stateProvider.state(home)
  $stateProvider.state(about)

  return
