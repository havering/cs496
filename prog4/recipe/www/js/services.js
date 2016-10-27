angular.module('starter.services', ['ngResource'])

.factory('Recipe', function ($resource) {
    return $resource('http://recipe.ezmaz2hnxw.us-west-2.elasticbeanstalk.com/recipes/:recipe_id');
});

