app = angular.module('melbjs-preso', [])

app.config ($routeProvider) ->
  $routeProvider
    .when('/:slideNr', {controller: 'BodyController', templateUrl: 'slide2'})
    .otherwise(redirectTo: '/1')

app.controller 'BodyController', ($scope, $routeParams) ->
  $scope.currentSlide = $routeParams.slideNr
