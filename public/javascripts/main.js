(function() {
  var app;

  app = angular.module('melbjs-preso', []);

  app.directive('slide', function() {
    return {
      restrict: 'E',
      template: "<div class='slide' ng-transclude ng-show='isShown()'></div>",
      replace: true,
      transclude: true,
      scope: true,
      link: function(scope, element, attrs) {
        var id;
        id = parseFloat(attrs.id);
        return scope.isShown = function() {
          return Math.floor(id) === Math.floor(scope.currentSlide);
        };
      }
    };
  });

  app.directive('step', function() {
    return {
      link: function(scope, element, attrs) {
        var id;
        id = parseFloat(attrs.step);
        return scope.$watch("currentSlide", function() {
          var visibility;
          visibility = Math.floor(id) === Math.floor(scope.currentSlide) && id <= scope.currentSlide ? 'visible' : 'hidden';
          return element.css('visibility', visibility);
        });
      }
    };
  });

  app.directive('snippet', function($http) {
    return {
      restrict: 'E',
      replace: true,
      template: "<pre><code data-language='{{lang}}'>{{content}}</code></pre>",
      scope: true,
      link: function(scope, element, attrs) {
        scope.lang = attrs.lang;
        scope.file = attrs.file;
        scope.iframeVisibility = function() {
          return {
            visibility: scope.iframeShown ? 'visible' : 'hidden'
          };
        };
        return $http.get(scope.file).success(function(data) {
          return scope.content = data;
        });
      }
    };
  });

  app.service('keyboard', function($rootScope, $document, $location) {
    var bindings;
    bindings = {};
    $document.bind('keydown', function(k) {
      var callback;
      if (callback = bindings[k.keyIdentifier]) {
        return $rootScope.$apply(callback);
      }
    });
    return this.on = function(keyIdentifier, callback) {
      return bindings[keyIdentifier] = callback;
    };
  });

  app.controller('BodyController', function($scope, $location, keyboard) {
    var setCurrentSlide;
    setCurrentSlide = function(nr) {
      var ohGodJavascriptReally;
      ohGodJavascriptReally = nr.toFixed(1);
      $location.hash(ohGodJavascriptReally);
      return $scope.currentSlide = parseFloat(ohGodJavascriptReally);
    };
    setCurrentSlide(parseFloat($location.hash()) || 1);
    keyboard.on("Right", function() {
      return setCurrentSlide(Math.floor($scope.currentSlide + 1));
    });
    keyboard.on("Left", function() {
      return setCurrentSlide(Math.floor($scope.currentSlide - 1));
    });
    keyboard.on("Down", function() {
      return setCurrentSlide($scope.currentSlide + 0.1);
    });
    return keyboard.on("Up", function() {
      return setCurrentSlide($scope.currentSlide - 0.1);
    });
  });

}).call(this);
