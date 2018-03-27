
var CollectionDriver = require('./collectionDriver').CollectionDriver;// see collectionDriver.js
var MongoClient = require('mongodb').MongoClient;
var Server = require('mongodb').Server;

var mongoHost = 'localHost'; // Running on the local machine. Can be changed to a Mongolab address, for example
var mongoPort = 27017; // default local mongo port
var collectionDriver;  // this will be our collection driver (for jsons). see collectiondriver.js for more

/**
 * Create and open a mongoclient (if found) and create the collection driver for it
 */
var mongoClient = new MongoClient(new Server(mongoHost, mongoPort));
mongoClient.open(function(err, mongoClient) {
  if (!mongoClient) {
      console.error("Error! Exiting... Must start MongoDB first");
      process.exit(1);
  }
  var db = mongoClient.db("MyDatabase");  // get our mongo database and name 'db' in this code
  collectionDriver = new CollectionDriver(db); // create the collection driver with our mongo database
});

var minutes = .2, the_interval = minutes * 60 * 1000;
setInterval(function() {
  collectionDriver.makeAllMatches("user", function(error, doc) {
    if (error) console.log(error);
    else {
      var d = new Date();
      console.log(doc + " Milliseconds since 1970 " + d.getTime());
    }
  });
}, the_interval);
