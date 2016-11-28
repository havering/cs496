// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers'])

.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleDefault();
    }
  });
})

.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider

    .state('app', {
    url: '/app',
    abstract: true,
    templateUrl: 'templates/menu.html',
    controller: 'AppCtrl'
  })

  .state('app.search', {
    url: '/search',
    views: {
      'menuContent': {
        templateUrl: 'templates/search.html'
      }
    }
  })

  .state('app.mynav', {
    url: '/mynav',
    views: {
      'menuContent': {
        templateUrl: 'templates/mynav.html'
      }
    }
  })

   .state('app.new', {
    cache: false,
    url: '/recipes/new',
    views: {
      'menuContent': {
        templateUrl: 'templates/new.html'
      }
    }
  })
    // reloading the controller with every view: http://stackoverflow.com/questions/27058276/run-a-controller-function-whenever-a-view-is-opened-shown
    .state('app.recipes', {
      cache: false,
      url: '/recipes',
      views: {
        'menuContent': {
          templateUrl: 'templates/recipes.html',
          controller: 'RecipesCtrl'
        }
      }
    })

  .state('app.recipe', {
    cache: false,
    url: '/recipes/:recipe_id',
    views: {
      'menuContent': {
        templateUrl: 'templates/recipe.html',
        controller: 'RecipeCtrl'
      }
    }
  })

  .state('app.edit', {
    cache: false,
    url: '/recipes/:recipe_id/edit',
    views: {
      'menuContent': {
        templateUrl: 'templates/edit.html',
        controller: 'RecipeCtrl'
      }
    }
  });
  // if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise('/app/mynav');
});
