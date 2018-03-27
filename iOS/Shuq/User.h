//
//  User.h
//  Shuq
//
//  Created by Joseph Min on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wishlist.h"
#import "Inventory.h"
#import "Settings.h"
/**
 This class that represents a user in the program. The user will have data associated with it, such as name, address, location, etc.. Users will also have ratings. User will have an inventory, which contains items that they want to trade. They will also have an wish list containing items that they want to trade for.
 */
@interface User : NSObject {
    
    /**
     username os the user, used for logging in
     */
    NSString* username;
    /**
     Unique id for the user on the database
     */
    NSString* unid;
    /**
     Location of the user
     */
    NSString* location;
    /**
     wishlist of the user
     */
    Wishlist* wishlist;
    /**
     inventory of the user
     */
    Inventory* inventory;
    /**
     Settings group
     */
    Settings *settings;
    /**
     Password of the user
     */
    NSString* password;
    /**
     Contact info of the user
     */
    NSString* contact;
}

/**
 Create a new user
 @param n name
 @param u username
 @param w wishlist
 @param i inventory
 */
-(id)initWithUsername:(NSString*)u andWishlist:(Wishlist*)w andInventory:(Inventory*)i andSettings:(Settings*)s andLocation:(NSString*) l andPassword:(NSString*)p;
/** 
 Iniatiates the object from a JSON
 */
- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
/**
 Returns the username
 @return username
 */
-(NSString*) getUsername;
/**
 Returns the wishlist containing the items that the user wants
 @return wishlist
 */
-(Wishlist*) getWishlist;
/**
 Returns the inventory contaning the items that the user has to offer
 @return inventory
 */
-(Inventory*) getInventory;
/**
 Checks the see if the passed password is equal to the users
 @return true if the password matches
 */
-(Boolean) checkPassword: (NSString*) p;
/**
 Returns the location of the user
 @return location
 */
-(NSString*) getLocation;
-(void) setLocation:(NSString*)loc;
/**
 Convert to JSONable object
 */
- (NSDictionary*) toDictionary;
/**
 Returns the ID of user
 @return id
 */
-(NSString*) getUniqueID;
/**
 Returns the password of user
 @return id
 */
-(NSString*) getPassword;
/**
 Returns the contactinfo of user
 @return contact
 */
-(NSString*) getContact;
/**
 Returns the contactinfo of user
 @return contact
 */
-(void) setContact: (NSString*) con;
/**
 Returns the JSON of just username and password
 */
- (NSDictionary*) toDictionarySimple;

@end
