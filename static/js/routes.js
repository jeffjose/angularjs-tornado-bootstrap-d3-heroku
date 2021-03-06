// Generated by CoffeeScript 1.10.0
"use strict";
app.config(function($stateProvider, $urlRouterProvider) {
  var about, home;
  $urlRouterProvider.otherwise('404');
  home = {
    name: 'home',
    url: '',
    templateUrl: 'static/partials/home.html',
    controller: 'SampleAppCtrl'
  };
  about = {
    name: 'about',
    url: '/about',
    templateUrl: 'static/partials/about.html',
    controller: 'SampleAppCtrl'
  };
  $stateProvider.state(home);
  $stateProvider.state(about);
});
