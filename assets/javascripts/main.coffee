app = angular.module('melbjs-preso', [])

app.directive 'slide', ($compile) ->
  restrict: 'E'
  template: "<div class='slide' ng-transclude ng-show='id == currentSlide'></div>"
  replace: true
  transclude: true
  scope: true
  link: (scope, element, attrs) -> scope.id = attrs.id

app.service 'keyboard', ($rootScope, $document, $location) ->
  bindings = {}

  $document.bind 'keydown', (k) ->
    if callback = bindings[k.keyIdentifier]
      $rootScope.$apply callback

  @on = (keyIdentifier, callback) ->
    bindings[keyIdentifier] = callback

app.controller 'BodyController', ($scope, $routeParams, keyboard) ->
  $scope.currentSlide = 1

  keyboard.on "Right", -> $scope.currentSlide += 1
  keyboard.on "Left", -> $scope.currentSlide -= 1
