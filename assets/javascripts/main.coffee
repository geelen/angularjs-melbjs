app = angular.module('melbjs-preso', [])

app.directive 'slide', ->
  restrict: 'E'
  template: "<div class='slide' ng-transclude ng-show='isShown()'></div>"
  replace: true
  transclude: true
  scope: true
  link: (scope, element, attrs) ->
    id = parseFloat attrs.id
    scope.isShown = ->
      Math.floor(id) == Math.floor(scope.currentSlide)

app.directive 'step', ->
  link: (scope, element, attrs) ->
    id = parseFloat attrs.step

    scope.$watch "currentSlide", ->
      visibility = if Math.floor(id) == Math.floor(scope.currentSlide) && id <= scope.currentSlide then 'visible' else 'hidden'
      element.css('visibility', visibility)

app.directive 'snippet', ($http) ->
  restrict: 'E'
  replace: true
  template: "<pre><code data-language='{{lang}}'>{{content}}</code></pre>"
  scope: true
  link: (scope, element, attrs) ->
    scope.lang = attrs.lang
    scope.file = attrs.file
    scope.iframeVisibility = -> visibility: if scope.iframeShown then 'visible' else 'hidden'
    $http.get(scope.file).success (data) ->
      scope.content = data

app.service 'keyboard', ($rootScope, $document, $location) ->
  bindings = {}

  $document.bind 'keydown', (k) ->
    if callback = bindings[k.keyIdentifier]
      $rootScope.$apply callback

  @on = (keyIdentifier, callback) ->
    bindings[keyIdentifier] = callback

app.controller 'BodyController', ($scope, $location, keyboard) ->
  setCurrentSlide = (nr) ->
    ohGodJavascriptReally = nr.toFixed(1)
    $location.hash(ohGodJavascriptReally)
    $scope.currentSlide = parseFloat(ohGodJavascriptReally)

  setCurrentSlide(parseFloat($location.hash()) || 1)

  keyboard.on "Right", -> setCurrentSlide(Math.floor($scope.currentSlide + 1))
  keyboard.on "Left", -> setCurrentSlide(Math.floor($scope.currentSlide - 1))
  keyboard.on "Down", -> setCurrentSlide($scope.currentSlide + 0.1)
  keyboard.on "Up", -> setCurrentSlide($scope.currentSlide - 0.1)
