angular.module('starter.controllers', ['starter.services'])

.controller('AppCtrl', function($scope, $ionicModal, $timeout, $http, $location) {

  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  // Form data for the login modal
  $scope.loginData = {};

  // Create the login modal that we will use later
  $ionicModal.fromTemplateUrl('templates/login.html', {
    scope: $scope
  }).then(function(modal) {
    $scope.modal = modal;
  });

  // Triggered in the login modal to close it
  $scope.closeLogin = function() {
    $scope.modal.hide();
  };

  // Open the login modal
  $scope.login = function() {
    $scope.modal.show();
  };

  // Perform the login action when the user submits the login form
  $scope.doLogin = function() {
    console.log('Doing login', $scope.loginData);

    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeLogin();
    }, 1000);
  };

  // POSTing with ionic: http://www.nikola-breznjak.com/blog/codeproject/posting-data-from-ionic-app-to-php-server/
  $scope.data = {};
 
    $scope.submitRecipe = function(){
        var link = 'http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/';
        console.log("Scope data contains: " + JSON.stringify($scope.data));
        $http.post(link, {name: $scope.data.name, description: $scope.data.description, instructions: $scope.data.instructions, cook_time: parseInt($scope.data.cook_time), serving_size: parseInt($scope.data.serving_size), quantity: $scope.data.quantity}).then(function (res){
            $scope.response = res.data;
            console.log("Response from POST: " + JSON.stringify($scope.response));
            $location.path('/recipes');
        });
    };
})

.controller('RecipesCtrl', function($scope, Api) {
  $scope.recipes = Api.Recipe.query();
})

.controller('RecipeCtrl', function($scope, $stateParams, Api) {
  console.log("recipe_id: " + parseInt($stateParams.recipe_id));
  $scope.recipe = Api.Recipe.get({recipe_id: parseInt($stateParams.recipe_id)});
  $scope.ingredients = Api.Ingredients.query({recipe_id: parseInt($stateParams.recipe_id)});
  console.log("ingredients: " + $scope.ingredients);
})
