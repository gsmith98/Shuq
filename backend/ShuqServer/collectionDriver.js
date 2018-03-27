/**
 * @fileoverview a helper class that handles a lot of interactions with the mongodb database
 */

var cDriver;

/**
 * The constructor for a collection driver object
 * @param db the database this collectiondriver deals with
 * @constructor
 */
CollectionDriver = function(db) {
  this.db = db;
  cDriver = this;
};

CollectionDriver.prototype.authorize = function(username, password, callback) {
  this.get("user", username, function(error, objs) {
    if (error || objs == null || objs.username == null) {
      console.log("user doesn't exist");
      callback("error");
    } else if (objs.password != password) {
      console.log("password doesn't match");
      callback("error");
    } else callback(null, objs);
  });
};

/**
 * The function that gets a collection
 * @param collectionName the name of the collection to get
 * @param callback the callback response
 */
CollectionDriver.prototype.getCollection = function(collectionName, callback) {
  this.db.collection(collectionName, function(error, the_collection) {
    if( error ) callback(error);
    else callback(null, the_collection);
  });
};


/**
 * Finds all the objects in the specified collection
 * @param collectionName the name of the collection whose objects you want
 * @param callback the callback response
 */
CollectionDriver.prototype.findAll = function(collectionName, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
      if( error ) callback(error);
      else {
        the_collection.find().toArray(function(error, results) {
          if( error ) callback(error);
          else callback(null, results);
        });
      }
    });
};

/**
 * Goes through the collection (should be "user") and detects every user's matches.
 * For every user, match JSON objects are created for each user they match with
 * and they are stored in the collection "<userID>Matches".
 * Will be called periodically by matchMaker.js
 * @param collectionName the collection to make matches with (user)
 * @param callback the callback response
 */
CollectionDriver.prototype.makeAllMatches = function(collectionName, callback) {
  this.findAll(collectionName, function(error, allUsers) {
    if (error) callback(error);
    else {
      for (var i=0; i<allUsers.length; i++) {
        var currentMatches = cDriver.matchesForOne(allUsers[i], allUsers);
        var userString = allUsers[i].username.concat("Matches");
        cDriver.deleteAll(userString, function(error, noerror) {
          if (error) callback(error);
        });
        if (currentMatches.length != 0) {
          cDriver.save(userString, currentMatches, function(error, response) {
            if (error) callback(error);
          });
        }
      }
      callback(null, "Matches Done");
    }
  });
};

/**
 * Goes through the collection (should be "user") and detects the specified user's matches.
 * For that user, match JSON objects are created for each user they match with
 * and they are stored in the collection "<userID>Matches".
 * This function exists for the purposes of the demo so the app can force matches to be made immediately.
 * @param collectionName the collection to make matches with (user)
 * @param callback the callback response
 */
CollectionDriver.prototype.demoMakeMatches = function(collectionName, id, callback) {
  var stringMatchCollection = id.concat("Matches");
  this.deleteAll(stringMatchCollection, function(error, response) {
    if (error) callback(error);
    else
    {
      cDriver.get(collectionName, id, function(error, user) {
        if (error) callback(error);
        else {
          cDriver.findAll(collectionName, function(error, allUsers) {
            if (error) callback(error);
            else {
              var arrayOfMatches = cDriver.matchesForOne(user, allUsers);
              if (arrayOfMatches.length != 0) {
                cDriver.save(stringMatchCollection, arrayOfMatches, function(error, response) {
                  if (error) { callback(error); }
                  else {
                    callback(response);
                    }
                });
              } else {
                callback(null, "No Matches");
              }
            }
          });
        }
      });
    }
  });
};


/**
 * Helper function to make all matches for a specific user.
 * Creates match JSONs for every match and returns an array of them.
 * @param userToMatch the user Json for whom we will find matches
 * @param arrayOfUsers the array of all users within which we should check for matches
 * @return an array of match Jsons
 */
CollectionDriver.prototype.matchesForOne = function(userToMatch, arrayOfUsers) {
  var matchedObjectsArray = [];

  // for every user in arrayOfUsers
  for (var i=0; i<arrayOfUsers.length; ++i) {
    var otherUser = arrayOfUsers[i];

    //don't match John with himself. Skip John
    if (otherUser.username == userToMatch.username) {
      continue;
    }


    //don't match users that are too far
    if (!(this.testZip(otherUser.location, userToMatch.location))) {
        continue;
    }

    var otherHas = [];
    var otherWants = [];
    var strength = 0;


    // check if he has something John wants
    // for every item in their inventory
    for (var k=0; k<otherUser.inventory.items.length; ++k) {
        var othersItem = otherUser.inventory.items[k];
        //for every item in John's wishlist
        for (var j=0; j<userToMatch.wishlist.items.length; ++j) {


        var thisStrength = this.checkMatch(userToMatch.wishlist.items[j], othersItem);
        if (thisStrength == 0){
          continue;
        }
        strength = strength + thisStrength;
        console.log(userToMatch.username + " adding " + othersItem.name + " to otherHas for " + otherUser.username);

        otherHas.push(othersItem);
        break;
      }

    }

    if (otherHas.length == 0) {
      continue;
    }



    //check the other direction (what John has that other wants)
    // for every item in John's inventory
    for (var j=0; j<userToMatch.inventory.items.length; ++j) {
      var myItem = userToMatch.inventory.items[j];
      //for every item in user i's wishlist
      for (var k=0; k<otherUser.wishlist.items.length; ++k) {


        /*if (myItem.name.toLowerCase().trim() != otherUser.wishlist.items[k].name.toLowerCase().trim()) {
          continue;
        }*/
        var thisStrength = this.checkMatch(myItem, otherUser.wishlist.items[k]);
        if (thisStrength < 0)
        {
          continue;
        }
        strength = strength + thisStrength;
        console.log(userToMatch.username + " adding " + myItem.name + " to otherWants for " + otherUser.username);

        otherWants.push(myItem);
        break;
      }
    }

    if (otherWants.length == 0) {
      continue;
    }

    var score = this.genScore(otherUser.location, userToMatch.location, otherHas, otherWants, strength);
    //Store a match object representing this match
    var matchObject =
        {
          username: otherUser.username,
          _id: otherUser.username,
          contact: otherUser.contact,
          userHas: otherHas,
          userWants: otherWants,
          score: score,
          rank: 0
        };

    matchedObjectsArray.push(matchObject);
  }

  matchedObjectsArray.sort(function(a,b) {
    return b.score - a.score;
  });

  for (var i=0; i<matchedObjectsArray.length; ++i) {
    matchedObjectsArray[i].rank = i+1;
  }

  return matchedObjectsArray;
};

CollectionDriver.prototype.checkMatch = function(a, b) {
  if (this.stringCompare(a.name,b.name)) {
    return 1;
  }
  var strength = b.tags.length + 2;
  var changed = 0;
  if (a.tags.length > b.tags.length) {
    strength = a.tags.length + 2;
  }
  else {
    for (var i=0; i<a.tags.length; i++) {
      for (var m=0; m<b.tags.length; m++) {
        if (this.stringCompare(a.tags[i],b.tags[m])) {
          strength = strength - 1;
          changed = 1;
        }
      }
    }
    if (changed) {
      return strength;
    }
    return 0;
  }
};


CollectionDriver.prototype.stringCompare = function(a, b) {
  var a_post = a.toLowerCase().trim();
  var b_post = b.toLowerCase().trim();
  if ((a_post == "") || (b_post == "")) {
    return false;
  }
  return a_post == b_post;
}

/**
 * Helper function used to determine whether 2 zip codes are considered 'in range' of each other.
 * This function is used to ensure matches are only made between users in range of each other.
 * Currently, zips are in range if the first 2 digits match
 * @param zip1 the zipcode string of one of the users
 * @param zip2 the zipcode string of the other user
 * @return true if the zips are in range, false otherwise
 */
CollectionDriver.prototype.testZip = function(zip1, zip2) {
  var int1 = parseInt(zip1);
  var int2 = parseInt(zip2);
  return (Math.abs(int1-int2) < 1000);
};

/**
 * Helper function creates a numerical score representing the strength of a match.
 * These scores are used to rank the matches from best to worst to give to the user.
 * Takes into account locations (zips) and the hot items involved.
 * @param zip1 the zipcode string of one of the users
 * @param zip2 the zipcode string of the other user
 * @param otherHas an array of item JSONS that user2 Has and user1 Wants
 * @param otherWants an array of item JSONS that user2 Wants and user1 Has
 * @return an integer score representing the strength of the match
 */
CollectionDriver.prototype.genScore = function(zip1, zip2, otherHas, otherWants, strength) {
  var totalMatches = otherHas.length + otherWants.length;
  var int1 = parseInt(zip1);
  var int2 = parseInt(zip2);
  return ((1000-(Math.abs(int1 - int2))) + (1000*totalMatches))/strength;
};


CollectionDriver.prototype.tagHelper = function(usernameToMatch, zip, tags, arrayOfUsers) {
  var tagMatchesArray = [];

  // for every user in arrayOfUsers
  for (var i=0; i<arrayOfUsers.length; ++i) {
    var otherUser = arrayOfUsers[i];

    //don't match John with himself. Skip John
    if (otherUser.username == usernameToMatch) {
      continue;
    }

    //don't match users that are too far
    if (!(this.testZip(otherUser.location, zip))) {
        continue;
    }

    var otherHas = [];

    // check if he has something John wants
    // for every tag provided
    for (var j=0; j<tags.length; ++j) {
      var currentTag = tags[j];
      //for every item in user i's inventory
      for (var k=0; k<otherUser.inventory.items.length; ++k) {
        var othersItem = otherUser.inventory.items[k];
        //for every tag of that item
        for (var l=0; l<othersItem.taglist.length; ++l) {
          var otherTag = othersItem.taglist[l].tagname;

          if ((currentTag.toLowerCase().trim() != otherTag.toLowerCase().trim()) &&
            (currentTag.toLowerCase().trim() != otherTag.toLowerCase().trim())) {

            continue;
          }

          //if we reach here, this item matches the search, add it and stop checking
          otherHas.push(othersItem);
          break;
        }
      }

    }

    if (otherHas.length == 0) {
      continue;
    }

    //Store a match object representing this match
    var matchObject =
        {
          username: otherUser.username,
          _id: otherUser.username,
          contact: otherUser.contact,
          userHas: otherHas
        };

    tagMatchesArray.push(matchObject);
  }

  return tagMatchesArray;
};


CollectionDriver.prototype.searchTags = function(collectionName, username, zip, tags, callback) {
  var stringSearchCollection = username.concat("Search");
  this.deleteAll(stringSearchCollection, function(error, response) {
    if (error) callback(error);
    else
    {
      cDriver.findAll(collectionName, function(error, allUsers) {
        if (error) callback(error);
        else {
          var arrayOfMatches = cDriver.tagHelper(username, zip, tags, allUsers);
          if (arrayOfMatches.length != 0) {
            cDriver.save(stringSearchCollection, arrayOfMatches, function(error, response) {
              if (error) callback(error);
              else callback(response);
            });
          } else {
            callback(null, "No results matched that search.");
          }
        }
      });
    }
  });
};

/**
 * Checks whether or not a given username exists in the ('user') collection yet.
 * Used by the app to ensure that a local user cannot be created unless available.
 * @param collectionName the collection to check. Should be 'user'
 * @param user the username to check for in the collection
 * @param callback the callback response
 */
CollectionDriver.prototype.check = function(collectionName, user, callback) {
  this.getCollection(collectionName, function(error, the_collection) {
    if (error) callback(error);
    else {
      the_collection.findOne({'username':user}, function(error, doc) {
        if(doc) {
          callback(null, "Taken");
        } else {
          callback(null, "Free");
        }
      });
    }
  });
};

/**
 * Grabs a specific object from a collection
 * @param collectionName the name of the collection
 * @param id the id of the entity you want to get
 * @param callback the callback response
 */
CollectionDriver.prototype.get = function(collectionName, id, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
            the_collection.findOne({'_id':id}, function(error,doc) {
                if (error) callback(error);
                else callback(null, doc);
            });
        }
    });
};



/**
 * Post an object to the desired collection
 * @param collectionName the name of the collection
 * @param obj the object to put into the collection
 * @param callback the callback response
 */
CollectionDriver.prototype.save = function(collectionName, obj, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
      if( error ) callback(error);
      else {
        obj.created_at = new Date();
/*        the_collection.insert(obj, function() {
          callback(null, obj);
          });
*/      the_collection.insert(obj, function(error, doc) {
            /*if (writeResult.nInserted === 1) {
                callback(null, obj);
            }*/
            if (error) callback(error);
            else {
                callback(null, obj);
            }
        });
      }
    });
};


/**
 * Put/update. Replace an entity in a collection with the given object
 * @param collectionName the name of the collection
 * @param obj the object to put in place of the specified entity
 * @param entityId the id of the entity to be overwritten/updated
 * @param callback the callback response
 */
CollectionDriver.prototype.update = function(collectionName, obj, entityId, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
	        obj._id = entityId;
	        obj.updated_at = new Date();
            the_collection.save(obj, function(error,doc) {
            	if (error) callback(error)
            	else callback(null, obj);
            });
        }
    });
};

/**
 * A variant of PUT update that takes a JSON representing delta changes
 * and updates entries in a collection. Would be used to avoid reuploading
 * large objects that have had a few minor changes made to them. Not currently
 * used by the app, would require a change in JSON format.
 * @param collectionName the collection to put into
 * @param obj the object representing the changes made (proper format)
 * @param entityId the _id of the entity being updated
 * @param callback the callback function
 */
CollectionDriver.prototype.partialUpdate = function(collectionName, obj, entityId, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
            the_collection.findOne({'_id': entityId}, function (error, doc) {
                if (error) callback(error);
                else {
                   //RIGHT NOW THIS ASSUMES GOOD INPUT
                    var index;
                    for (index = 0; index < obj.changes.length; ++index) {
                        var change = obj.changes[index];
                        var path = change.path.split(".");
                        var navigator = doc;
                        var j;
                        for (j=0; j<path.length; ++j) {
                            navigator = navigator[path[j]];
                        }

                        if (change.type === "add") {
                            navigator[change.propertyName] = change.propertyValue;

                        } else if (change.type === "remove") {
                            delete navigator[change.propertyName];

                        } else if (change.type === "replace") {
                            navigator = change.propertyValue;

                        }
                    }

                    the_collection.save(doc, function (error, doc2) {
                        if (error) callback(error)
                        else callback(null, doc);
                    });
                }
            });
        }
    });
};


/**
 * Delete an entity from a collection
 * @param collectionName the name of the collection
 * @param entityId the id of the entity to delete
 * @param callback the callback response
 */
CollectionDriver.prototype.delete = function(collectionName, entityId, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
            the_collection.remove({'_id': entityId}, function(error,doc) {
            	if (error) callback(error)
            	else callback(null, doc);
            });
        }
    });
};


CollectionDriver.prototype.getXY = function(collectionName, x, y, callback) {
  this.getCollection(collectionName, function(error, the_collection) {
    if (error) callback(error);
    else {
      the_collection.find({'rank': {"$gte": x, "$lte":y}}, function(error, doc) {
        if (error) callback(error);
        doc.toArray(function(error, doc) {
          if (error) callback(error);
          callback(doc);
        });
      });
    }
  });
};

/**
 * Delete every entity from a collection
 * @param collectionName the name of the collection
 * @param callback the callback response
 */
CollectionDriver.prototype.deleteAll = function(collectionName, callback) {
    this.getCollection(collectionName, function(error, the_collection) {
        if (error) callback(error);
        else {
          the_collection.remove({}, function(error,doc) {
            	if (error) callback(error)
              else {
                callback(null, doc);
              }
          });
        }
    });
};

exports.CollectionDriver = CollectionDriver;
