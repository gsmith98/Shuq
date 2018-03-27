//
//  Communicator.h
//  Shuq
//
//  Created by Joshua Barza on 12/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Reachability.h"

@interface Communicator : NSObject {
    /** URL of the server*/
    NSString* server;
    /** Name of the collection that stores users*/
    NSString* userLoc;
    /** Name of the collection that stores files*/
    NSString* files;
    /** AppleAPI object that allows to check connection to the server*/
    Reachability* reachability;
}

/** Contructor for a new commnicator
 @param ser URL of the server
 @param us name of the collection of users
 @param name of the collections for files
 */
-(id)initWithServer: (NSString*) ser AndUser:(NSString*) us AndFile: (NSString*) fil;
/**
 Puts the specified user to the server
 @param user the user to put
 @param JSON of the updated user
 */
-(NSArray*)updateUser:(User*)user;

/**
 Makes a call to run the match algorith on the server.
 @param user the user to make matches for
 */
-(void)runUserMatches:(User*)user;

/**
 Calls the server to get the matched items JSON for the user
 @param username the user the get the item matches
 @return return JSON of opjects
*/
 -(NSArray*)getMatchItems:(User*)username;

/** Post a new item image to the server
 @param item the item with an image to call
 @param us user that the item is
 */
- (void) saveNewItemImage:(Item*)item andUser: (User*) us;

/**
 Loads an image of an item from the server
 @param the item to load photos
 */
- (void) loadImage:(Item*)item andUser: (User*) us;

/**
 Checks to see if the username exists exists on the server
 @return whether or not the username already exists
 */
-(BOOL) checkUsernameExists:(NSString*)username;

/**
 Tries to log-in the user with the given username and password
 @param user the username
 @param pass the password
 @return JSON of the user if sucessful, nil otherwise
 */
-(NSArray*)getUserFromServerWithUsername:(NSString*)user andPassword:(NSString*)pass;

/**
 Creates a new user
 @param user the username
 @param pass the password
 @return JSON of the user if sucessful, nil otherwise
 */
-(NSArray*)addNewUserToServerWithUsername:(NSString*)username andPassword:(NSString*)password;


/**Calls a get request on the given URL
 @param URLLod url location
 @return the repsonse from the get call.
 */
- (NSArray*) getRequest: (NSString*) URLLoc;

/**
 Checks the internet connection
 @return true if there is an internet connection, false otherwise*/
- (BOOL) checkInternet;
@end
