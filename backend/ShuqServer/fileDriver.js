/**
 * @fileoverview a helper class that handles file storage/retrieval for the mongodb database
 * @type {exports.ObjectID|*}
 */

var ObjectID = require('mongodb').ObjectID
  , fs = require('fs');

/**
 * Constructor for a FileDriver object.
 * @param db the database the file driver serves
 * @constructor
 */
FileDriver = function(db) {
  this.db = db;
};


/**
 * The function that gets the collection 'files'.
 * @param callback the callback response
 */
FileDriver.prototype.getCollection = function(callback) {
  this.db.collection('files', function(error, file_collection) {
    if( error ) callback(error);
    else callback(null, file_collection);
  });
};

/**
 * Grabs a specific file from 'files' (stored in '/uploads')
 * Used by FileDriver.handleGet.
 * @param id the id (and name without extension) of the file you want to get
 * @param callback the callback response
 */
FileDriver.prototype.get = function(id, callback) {
    this.getCollection(function(error, file_collection) {
        if (error) callback(error)
        else {
            var checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$");
            if (!checkForHexRegExp.test(id)) callback({error: "invalid id"});
            else file_collection.findOne({'_id':ObjectID(id)}, function(error,doc) {
            	if (error) callback(error)
            	else callback(null, doc);
            });
        }
    });
}

/**
 * Grabs a specific file from 'files' (stored in '/uploads') using
 * FileDriver.get and then sends it as a response.
 * @param req a request that specifies the id to grab
 * @param res the response
 */
FileDriver.prototype.handleGet = function(req, res) {
    var fileId = req.params.id;
    if (fileId) {
        this.get(fileId, function(error, thisFile) {
            if (error) { res.send(400, error); }
            else {
                    if (thisFile) {
                         var filename = fileId + thisFile.ext;
                         var filePath = './uploads/'+ filename;
    	                 res.sendfile(filePath);
    	            } else res.send(404, 'file not found');
            }
        });
    } else {
	    res.send(404, 'file not found');
    }
}

/**
 * Stores the json representation in the 'files' collection. Used in FileDriver.getNewFileId.
 * @param obj the json object to store
 * @param callback the callback response
 */
FileDriver.prototype.save = function(obj, callback) {
    this.getCollection(function(error, the_collection) {
      if( error ) callback(error)
      else {
        obj.created_at = new Date();
        the_collection.insert(obj, function() { //insert gives an id to the object
          callback(null, obj);
        });
      }
    });
};

/**
 * Stores the json representation in the 'files' collection (by calling FileDriver.save)
 * and returns in a response the _id that is automatically assigned by a call to mongodb's
 * insert. Used by FileDriver.handleUploadRequest.
 * @param newobj the json object to store
 * @param callback the callback response (for returning the id or error)
 */
FileDriver.prototype.getNewFileId = function(newobj, callback) {
	this.save(newobj, function(err,obj) {
		if (err) { callback(err); }
		else { callback(null,obj._id); }
	});
};

/**
 * Uploads the file to the server (stored in '/uploads' as <assigned_id>.<extension>),
 * stores a json representation of it in the 'files' collection after assigning an _id,
 * (by using FileDriver.getNewId), and returns the assigned _id in the response.
 * @param req a request providing the necessary details (type and file and such)
 * @param res the response (for returning the id or error)
 */
FileDriver.prototype.handleUploadRequest = function(req, res) {
    var ctype = req.get("content-type");
    var ext = ctype.substr(ctype.indexOf('/')+1);
    if (ext) {ext = '.' + ext; } else {ext = ''};
    this.getNewFileId({'content-type':ctype, 'ext':ext}, function(err,id) {
        if (err) { res.send(400, err); }
        else {
             var filename = id + ext;
             filePath = __dirname + '/uploads/' + filename;

	           var writable = fs.createWriteStream(filePath);
	           req.pipe(writable);
             req.on('end', function (){
               res.send(201,{'_id':id});
             });
             writable.on('error', function(err) {
                res.send(500,err);
             });
        }
    });
};

exports.FileDriver = FileDriver;
