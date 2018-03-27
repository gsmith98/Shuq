/**
 * @fileOverview index javascript code gets from localhost
 */

var express = require('express');
var router = express.Router();
var appJs = require('../app');
var collection = appJs.collection;
/* GET home page. */
router.get('/*', function(req, res) {
  res.render('index', { title: 'Express' });
  console.log(req.url);

  collection.find().toArray(function(err, result) {
    console.log(result);
  });

});

module.exports = router;
