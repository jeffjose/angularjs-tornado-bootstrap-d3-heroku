"use strict"

app = angular.module "sampleApp",[

  "ui.router"

]

app.run ($window, $rootScope, $state, $stateParams) ->

  # Globaly expose these services
  $rootScope.$window      = $window
  $rootScope.$state       = $state
  $rootScope.$stateParams = $stateParams

  return

