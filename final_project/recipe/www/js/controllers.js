angular.module('starter.controllers', ['starter.services', 'ngCordova'])

.controller('AppCtrl', function($scope, $ionicModal, $timeout, $http, $location, Api, $window, $cordovaGeolocation, Auth, $state, $rootScope) {

  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:

  // POSTing with ionic: http://www.nikola-breznjak.com/blog/codeproject/posting-data-from-ionic-app-to-php-server/
  $scope.data = {};
 
  $scope.submitRecipe = function(recipeForm){
    $scope.recipeForm = recipeForm;
      var link = 'http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/';
      console.log("Scope data contains: " + JSON.stringify($scope.data));
      $http.post(link, {name: $scope.data.name, description: $scope.data.description, instructions: $scope.data.instructions, cook_time: parseInt($scope.data.cook_time), serving_size: parseInt($scope.data.serving_size), quantity: $scope.data.quantity, user_id: $scope.authData.google.id}).then(function (res){
          $scope.response = res.data;
          console.log("Response from POST: " + JSON.stringify($scope.response));
          // $location.path('/recipes');
          $state.go('app.recipes');
        });
      $scope.recipeForm.$setPristine(); // clear the form 
      $scope.data = {};
    };

  // functions to add or remove ingredient fields from form
  $scope.inputs = [
      { value: null }
    ];

  $scope.addInput = function () {
    $scope.inputs.push({ value: null });
  }

  $scope.removeInput = function (index) {
    $scope.inputs.splice(index, 1);
  }

  // function to allow jump to different view
  // guidelines from: http://stackoverflow.com/questions/11784656/angularjs-location-not-changing-the-path
  $scope.gotorecipes = function(){ 
    $window.location.assign('#/app/recipes');
  }
 
  // function to determine where the user is located
  // cordovaGeolocation example: http://stackoverflow.com/questions/34850918/ionic-reverse-geocoding
  var posOptions = {timeout: 10000, enableHighAccuracy: false};
   $cordovaGeolocation
   .getCurrentPosition(posOptions)
  
   .then(function (position) {
      $scope.lat  = position.coords.latitude;
      $scope.long = position.coords.longitude;
      console.log($scope.lat + '   ' + $scope.long);

      // now call the openstreetmap api
      $scope.fullAddress = Api.Address.get({latitude: $scope.lat, longitude: $scope.long});
      console.dir($scope.fullAddress);
    
   }, function(err) {
      console.log(err)
   });

   // set regex to detect if number is entered or not
   $scope.regex = '\\d+';

   $scope.loginWithGoogle = function() {
    Auth.$authWithOAuthPopup('google')
      .then(function(authData) {
        console.log(authData);
        $scope.authData = authData;
        $rootScope.authData = authData;
        console.log("************");
        $state.go('app.mynav');
      });
  }

  $scope.logoutWithGoogle = function() {
    console.log("inside logoutWithGoogle");
    Auth.$unauth();
    $http.jsonp('https://accounts.google.com/logout');
    $rootScope.authData = "";
    $state.go('login');
  }
}) // end of AppCtrl

.controller('RecipesCtrl', function($scope, Api) {
  $scope.recipes = Api.Recipe.query();
})

.controller('RecipeCtrl', function($scope, $stateParams, Api, $location, $http, $state, $rootScope) {
  $scope.userId = $rootScope.authData.google.id;

  console.log("recipe_id: " + parseInt($stateParams.recipe_id));
  $scope.recipe = Api.Recipe.get({recipe_id: parseInt($stateParams.recipe_id)});
  $scope.ingredients = Api.RecipeIngredients.query({recipe_id: parseInt($stateParams.recipe_id)});

  // using .then on promise return to set variables: http://stackoverflow.com/questions/25045861/accessing-promises-elements-which-are-objects-and-not-simple-types
  $scope.recipe.$promise.then(function(recipe) {
    $scope.recipe.cook_time = parseInt($scope.recipe.cook_time);
    $scope.recipe.serving_size = parseInt($scope.recipe.serving_size);
    $scope.recipe.user_id = parseInt($scope.recipe.user_id);

  })

  $scope.deleteRecipe = function() {
    Api.Recipe.delete({recipe_id: parseInt($stateParams.recipe_id)});
    // $location.path('/recipes');
    $state.go('app.mynav');
  }

  // using put: http://techfunda.com/howto/573/http-put-server-request
  $scope.submitEditRecipe = function(recipeForm) {
      $scope.recipeForm = recipeForm;
      var link = 'http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/' + $stateParams.recipe_id;

      $http.put(link, {name: $scope.recipe.name, description: $scope.recipe.description, instructions: $scope.recipe.instructions, cook_time: parseInt($scope.recipe.cook_time), serving_size: parseInt($scope.recipe.serving_size), quantity: $scope.recipe.quantity, user_id: $scope.recipe.user_id}).then(function (res){
          $scope.response = res.data;
          console.log("Response from POST: " + JSON.stringify($scope.response));
          // $location.path('/recipes');
          $state.go('app.recipes');
        });
      $scope.recipeForm.$setPristine(); // clear the form 
    };

});

