
/**
 * @fileoverview The main server code, run by "node ." or "node index.js".
 * This controls express behaviour and runs the database by handling CRUD requests.
 * This code and both 'drivers' were produced with great help from the tutorial found here:
 * http://www.raywenderlich.com/61078/write-simple-node-jsmongodb-web-service-ios-app
 * which walked us through the basics. Code is still in development.
 */

/**
 * Importing necessary modules
 */
var http = require('http'),
    express = require('express'),
    path = require('path'),
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    CollectionDriver = require('./collectionDriver').CollectionDriver, // see collectionDriver.js
    FileDriver = require('./fileDriver').FileDriver; // see fileDriver.js

/**
 * Set up our express instance (named 'app')
 */
var app = express();
app.set('port', process.env.PORT || 3000); // default port is 3000
app.set('views', path.join(__dirname, 'views')); // allows jade formattings to be stored in the views folder
app.set('view engine', 'jade');
app.use(express.bodyParser()); // parses request body -> then if it represents a json, we can just treat it as a json in this code

var mongoHost = 'localHost'; // Running on the local machine. Can be changed to a Mongolab address, for example
var mongoPort = 27017; // default local mongo port
var collectionDriver;  // this will be our collection driver (for jsons). see collectiondriver.js for more
var fileDriver; //this will be our fileDriver (for photos or other files). See fileDriver.js for more

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
  fileDriver = new FileDriver(db); // create the file driver with our mongo database
});


app.use(express.static(path.join(__dirname, 'public'))); // allows static directories of express to have their html specified in the folder 'public'

/**
 * This code determines what express shows when you navigate to its root. The welcome page.
 */
app.get('/', function (req, res) {
  res.send("<html><body><h1>Welcome to shuq's express page!</h1><br><br>For more info, append \"/README.html\" to your navigation bar.</body></html>");
});


/**
 * This code handles what happens when you try to post to /files. This destination is reserved for files,
 * in our case images. FileDriver handles most of the work for storing these.
 */
app.post('/files', function(req,res) {fileDriver.handleUploadRequest(req,res);});

/**
 * This code handles what happens when you try to get a file from /files. This destination is reserved for files,
 * in our case images. The requested file should be gotten if found, see filedriver for more info.
 */
app.get('/files/:id', function(req, res) {fileDriver.handleGet(req,res);});

/**
 *  This code determines what express shows when you navigate to a subfolder of the root that has not been statically declared.
 *  It will display the contents of the collection with that name in the format specified in data.jade
 *  (still works if collection is empty or was never created, just has a header and no table)
 */
app.get('/:collection', function(req, res) {
   var params = req.params;
   var entityArray = req.params.collection.split(":")
   if (entityArray.length != 3) {
    res.send(400, {error: 'Username and password must be sent', url: req.url});
    return;
  }
  var collection = entityArray[0];
  var username = entityArray[1];
  var password = entityArray[2];

  collectionDriver.authorize(username, password, function(error, objs) {
    console.log("error: " + error + " objs: " + objs);
    if (error) {
      console.log("the error " + error);
      res.send(400, {error: 'Incorrect username/password combination.', url: req.url});
      return;
    }  else {
       collectionDriver.findAll(collection, function(error, objs) {
    	   if (error) { res.send(400, error); }
	       else {
	          if (req.accepts('html')) {
    	        res.render('data',{objects: objs, collection: req.params.collection}); // use data.jade format
            } else {
	            res.set('Content-Type','application/json');
              res.send(200, objs);
            }
         }
       });
      }
   	});
});

/**
 * This code determines what express shows when you navigate to a subfolder of a collection.
 * The entity field should be an _id of an entry in that collection.
 * A well-formatted representation of that entry's json is displayed in the browser if the _id is valid.
 * If the _id is invalid, the display appears as the json: {"error":"invalid _id"}.
 *
 * This code is also used to verify username/password combos. In this case, collection is auth and
 * entity is username:password
 */
app.get('/:collection/:entity', function(req, res) {
   var params = req.params;
   var entity = params.entity;
   var collection = params.collection;

  var entityArray = entity.split(":");
  if (entityArray.length != 3) {
    res.send(400, {error: 'Username and password must be sent', url: req.url});
    return;
  }
  entity = entityArray[0];
  var username = entityArray[1];
  var password = entityArray[2];


  // url to check if a user exists in the database
  if (collection == "userCheck") {
    collectionDriver.check("user", entity, function(error, objs) {
      if (error) {
        res.send(400, error);
        return;
      } else {
        res.send(200,objs);
        return;
      }
    });
  }

  collectionDriver.authorize(username, password, function(error, objs) {
    console.log("error: " + error + " objs: " + objs);
    if (error) {
      console.log("the error " + error);
      res.send(400, {error: 'Incorrect username/password combination.', url: req.url});
      return;
    }  else {

      if (params.collection == "auth") {
        res.send(200, objs);
        return;
      }

      // url to use for forcing matches to be made
      else if (collection == "demoMakeMatches") {
        collectionDriver.demoMakeMatches("user", entity, function(error, response) {
          if(error) {res.send(400, error);}
          else {res.send(200, response);}
        });
      }

       // normal url path /collection/itemInCollection
       else if (entity) {
           collectionDriver.get(collection, entity, function(error, objs) {
              if (error) { res.send(400, error); }
              else { res.send(200, objs); }
           });
       } else {
          res.send(400, {error: 'bad url', url: req.url});
       }
    }
  });
});

app.get('/:collection/:x/:y', function(req, res) {
   var params = req.params;
   var x = params.x;
   var y = params.y;
   var collection = params.collection;

  collectionDriver.getXY(collection, parseInt(x), parseInt(y), function(err, docs) {
    if (err) { res.send(400, err); }
    else { res.send(200, docs); }
  });
});

/**
 * This code handles the functionality of posting a json to a specified collection
 * The request's body specifies the json to store and the collection driver does the rest.
 */
app.post('/:collection', function(req, res) {
    var object = req.body;
    var collection = req.params.collection;
    collectionDriver.save(collection, object, function(err,docs) {
          if (err) { res.send(400, err); }
          else { res.send(201, docs); }
     });
});

/**
 * This code handles put requests, that is, requests to update (replace only, for now) an entry in the collection.
 * An entity in a collection is specified (if collection but no entity, response contains an error message),
 * and the provided json replaces it.
 */
app.put('/:collection/:entity', function(req, res) {
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;

    if (entity) {
       collectionDriver.update(collection, req.body, entity, function(error, objs) {
          if (error) { res.send(400, error); }
          else { res.send(200, objs); }
       });
   } else {
	   var error = { "message" : "Cannot PUT a whole collection" }
	   res.send(400, error);
   }
});

/**
 * This code is for put requests made to the special searchTags url.
 * This is how to populate the collection "<username>Search" with
 * results from active search.
 */
app.put('/searchTags/:name/:location', function(req, res) {
    var params = req.params;
    var name = params.name;
    var location = params.location;

    //specialized put for performing tag searches
    // req.body should be of form {"tags" : ["blue", "suede"]}
    collectionDriver.searchTags("user", name, location, req.body.tags, function(error, response) {
      if(error) {res.send(400, error);}
      else {res.send(200, response);}
    });
});

app.put('/partial/:collection/:entity', function(req, res) {
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;
    if (entity) {
        collectionDriver.partialUpdate(collection, req.body, entity, function(error, objs) {
            if (error) { res.send(400, error); }
            else { res.send(200, objs); }
        });
    } else {
        var error = { "message" : "Cannot partial PUT a whole collection" }
        res.send(400, error);
    }
});

app.delete('/:collection', function(req, res) {
    var params = req.params;
    var collection = params.collection;
    collectionDriver.deleteAll(collection, function(error, objs) {
      if (error) { res.send(400, error);}
      else { res.send(200, objs); } // 200 b/c includes the original doc
    });
});



/**
 * This code handles the Delete functionality, the last of CRUD.
 * An entity in a collection is specified (if collection but no entity, response contains an error message),
 * and that entry is removed from the collection.
 */
app.delete('/:collection/:entity', function(req, res) {
    var params = req.params;
    var entity = params.entity;
    var collection = params.collection;
    collectionDriver.delete(collection, entity, function(error, objs) {
      if (error) { res.send(400, error); }
      else { res.send(200, objs); } // 200 b/c includes the original doc
    });
});

/** 404 code for unintelligible request. Uses 404.jade message*/
app.use(function (req,res) {
    res.render('404', {url:req.url}); // makes a webpage using 404.jade's error message html
});

/**
 * Starts the server on 'port' (3000 by default) and indicates as much in console.
 */
http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
