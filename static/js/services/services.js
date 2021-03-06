// Generated by CoffeeScript 1.10.0
"use strict";
angular.module("sampleApp").service("sampleAppService", [
  "$http", function($http) {
    this["search"] = function(host) {
      var url;
      url = "ip/" + host;
      return $http.get(url);
    };
  }
]);

angular.module("sampleApp").service("sampleWSAppService", [
  "$q", "$rootScope", function($q, $rootScope) {
    var _listener, callbacks, currentCallbackId, e, error, host, initDefer, requestsBacklog, sendRequest, uri, ws;
    _listener = function(data) {
      var messageObj;
      messageObj = data;
      if (callbacks.hasOwnProperty(messageObj.callback_id)) {
        $rootScope.$apply(callbacks[messageObj.callback_id].cb.resolve(messageObj.data));
        delete callbacks[messageObj.callbackID];
      }
    };
    sendRequest = function(request) {
      var callbackId, data, defer;
      defer = $q.defer();
      callbackId = "xxxxxxxxx".replace(/[xy]/g, function(c) {
        var r, v;
        r = Math.random() * 16 | 0;
        v = (c === "x" ? r : r & 0x3 | 0x8);
        return v.toString(16);
      });
      data = {};
      data.request = request;
      data.callback_id = callbackId;
      callbacks[callbackId] = {
        cb: defer
      };
      if (ws.readyState !== 0) {
        ws.send(JSON.stringify(data));
      } else {
        requestsBacklog.push(data);
      }
      return defer.promise;
    };
    callbacks = {};
    currentCallbackId = 0;
    requestsBacklog = [];
    host = window.location.host;
    uri = "ws://" + host + "/ws/ip";
    console.log("Connecting to " + uri);
    initDefer = $q.defer();
    initDefer.promise.then(function(x) {
      var i, len, request;
      for (i = 0, len = requestsBacklog.length; i < len; i++) {
        request = requestsBacklog[i];
        ws.send(JSON.stringify(request));
      }
    });
    try {
      ws = new WebSocket(uri);
    } catch (error) {
      e = error;
      ws = new MozWebSocket(uri);
    }
    ws.onopen = function() {
      $rootScope.$apply(initDefer.resolve(true));
    };
    ws.onmessage = function(message) {
      _listener(JSON.parse(message.data));
    };
    this.checkHostname = function(hoststring) {
      var promise;
      promise = sendRequest(hoststring);
      return promise;
    };
  }
]);
