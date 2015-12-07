module.service "sampleAppService", [

  "$http"

  ($http) ->

    # Expose this method so that sampleAppCtrl can use it
    this["search"] = (host) ->
      url = "ip/" + host
      $http.get url

    return
  ]
  

# sampleWSAppService provides a WebSocket communication service. 
# This very well could have been inside `sampleAppService`, but is
# kept seperate to keep it more organized.
module.service "sampleWSAppService", [

  "$q"
  "$rootScope"

  ($q, $rootScope) ->
  
    # Create our websocket object with the address to the websocket
    _listener = (data) ->
      messageObj = data
      
      # If an object exists with callback_id in our callbacks object, resolve it
      if callbacks.hasOwnProperty(messageObj.callback_id)
        $rootScope.$apply callbacks[messageObj.callback_id].cb.resolve(messageObj.data)
        delete callbacks[messageObj.callbackID]
      return
    
    # Keep track of requests via a random callback_id
    # so that when the result gets back from backend, 
    # we know what the original request was.
    sendRequest = (request) ->
      defer = $q.defer()
      
      # Generate a random callbackId
      callbackId = "xxxxxxxxx".replace(/[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = (if c is "x" then r else (r & 0x3 | 0x8))
        v.toString 16
      )
      data = {}
      data.request = request
      data.callback_id = callbackId
      callbacks[callbackId] = cb: defer
      unless ws.readyState is 0
        ws.send JSON.stringify(data)
      else
        requestsBacklog.push data
      defer.promise

    callbacks = {}
    currentCallbackId = 0
    requestsBacklog = []
    host = window.location.host
    uri = "ws://" + host + "/ws/ip"
    console.log "Connecting to " + uri
    initDefer = $q.defer()
    initDefer.promise.then (x) ->

      for request in requestsBacklog
        ws.send(JSON.stringify(request))

      return

    try
      ws = new WebSocket(uri)
    catch e
      ws = new MozWebSocket(uri)
    ws.onopen = ->
      $rootScope.$apply initDefer.resolve(true)
      return

    ws.onmessage = (message) ->
      _listener JSON.parse(message.data)
      return

    
    # This is what everybody from outside would access. 
    # Since we dont know when the result would appear on WebSocket, 
    # quickly create a promise and return.
    #
    @checkHostname = (hoststring) ->
      promise = sendRequest(hoststring)
      promise

    return
]
