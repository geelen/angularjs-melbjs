app = angular.module('melbjs-preso', [])

app.config ($routeProvider) -> $routeProvider
  .when('/:slideNr', controller: 'BodyController', template: "<div id='stage' ng-include='currentSlide()'>")
  .otherwise(redirectTo: '/1')

app.service 'keyboard', ($rootScope, $document, $location) ->
  bindings = {}

  $document.bind 'keydown', (k) ->
    if path = bindings[k.keyIdentifier]
      $rootScope.$apply $location.path(path).replace()

  @changePathOn = (keyIdentifier, callback) ->
    bindings[keyIdentifier] = callback

app.controller 'BodyController', ($scope, $routeParams, keyboard) ->
  slideNr = parseInt($routeParams.slideNr)
  $scope.currentSlide = -> "/slides/#{slideNr}.html"

  keyboard.changePathOn "Right", "/#{slideNr + 1}"
  keyboard.changePathOn "Left", "/#{slideNr - 1}"
