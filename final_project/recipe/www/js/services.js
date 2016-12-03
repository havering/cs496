angular.module('starter.services', ['firebase', 'ngResource'])

.factory('Auth', Auth)

// multiple GETs in one factory: http://stackoverflow.com/questions/17233481/angularjs-creating-multiple-factories-for-every-endpoint
.factory('Api', function ($resource) {
    return {
    	Recipe: $resource('http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/:recipe_id'),
    	RecipeIngredients: 	$resource('http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/:recipe_id/ingredients'),
    	Address: $resource('http://nominatim.openstreetmap.org/reverse?format=json&lat=:latitude&lon=:longitude&addressdetails=1')
    };
});


function Auth(rootRef, $firebaseAuth) {
  return $firebaseAuth(rootRef);
}
Auth.$inject = ['rootRef', '$firebaseAuth'];