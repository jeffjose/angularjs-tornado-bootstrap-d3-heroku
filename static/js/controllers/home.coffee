module.controller "sampleAppCtrl", [

  "$scope"
  "$http"
  "sampleAppService"
  "sampleWSAppService"

  ($scope, $http, sampleAppService, sampleWSAppService) ->

    # Declare our variables here.
    $scope.host = ""
    
    # Define an initial set
    $scope.chartData = "[1,2,10,3]"
    
    # This variable has our results that come from backend
    $scope.results = []
    
    # This variable has results from the WebSocket backend
    $scope.hoststatus = []
    
    # The following method is accesible from DOM (html) as `search()`
    # .. and is what gets activiated when you click the <button>
    $scope.search = ->
      sampleAppService.search($scope.host).then (result) ->
        $scope.results = result.data
        return

      return

    
    # The following method is accesible from DOM (html) as `checkHoststring()`
    # .. and is activiated everytime you press a key on your keyboard.
    $scope.checkHoststring = ->
      sampleWSAppService.checkHostname($scope.host).then (result) ->
        $scope.hoststatus = result
        return

      return

    return
]
