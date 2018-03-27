//
//  ShuqModel.h
//  Shuq
//
//  Created by Joseph Min on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Communicator.h"
/** This is local model for the application that will run on the iphone. It will handle setting up the connection to the server. It will allow user to login or signup into a local user object. It will also contain a list of Users that have been matched to the local user via an active or passive search.
 
 */
@interface ShuqModel : NSObject {
    /**
    The local user
     */
    User *primaryUser;

    /**Dictionay that maps forgeign items to the contact information of the person that has the item*/
    NSMutableArray* contacts;
    
    BOOL _isValid;
    /**Communicator to talk with the server*/
    Communicator *com;
}

/**
 the list of items that the user has been matched to 
 */
@property NSMutableArray* items;

-(void)getMatchItems:(User*)username;


/**
    Create the ShuqModel
 */
-(id)init;

/**
 Returns the primary user
 @return the primary user
 */
-(User*)getPrimaryUser;
/**
 Authenticate the given username/password combo
 @return a boolean whether or not it was valid
 */
-(BOOL)authenticateUser:(NSString*)username andPassword: (NSString*)password isNewUser:(BOOL)newUser;

/**
 Puts the specified user to the server
 @param user the user to put
 */
-(void)updateUser:(User*)user;


/**
 gets the global varable of the model
 */
+(id)getModel;

/**
 Makes a call to run the match algorith on the server.
 */
-(void)runUserMatches:(User*)user;

/**
 Post a new item image to the server
 */
- (void) saveNewItemImage:(Item*)item;

/**
 Loads an image of an item from the server
 */
- (void) loadImage:(Item*)item;

/**
 Gets the primary user from a JSON object
 @param users array of json user items
 @param destinationArray arrray to store users
 */

- (void) getParsePrimaryUser:(NSArray*) us;
/**
 Gets the primary user from a JSON object after a post request
 @param users array of json user items
 @param destinationArray arrray to store users
 */

- (void) parseAndSetPrimaryUser:(NSArray*) us;
/**
 Gets the items objects from an array of JSON item objects
 @param it array of json items
 @param destinationArray arrray to store items
 @param and 
 */
- (void) parseAndGetItems:(NSArray*) it toArray:(NSMutableArray*) destinationArray andContact: (NSString*) con;
/**
 Returns the contact information associated with the item
 @param item
 @return the phone number
 */
- (NSString*) getContact: (Item*) it;

@end
