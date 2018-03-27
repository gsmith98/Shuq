//
//  ShuqModel.m
//  Shuq
//
//  Created by Joseph Min on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "ShuqModel.h"
#import "Communicator.h"

@implementation ShuqModel

//static NSString* const kBaseURL = @"http://localhost:3000/";
//static NSString* const kBaseURL = @"http://Elanas-MacBook-Pro.local:3000";
static NSString* const kBaseURL = @"http://ec2-54-149-70-227.us-west-2.compute.amazonaws.com:3000";
static NSString* const kLocations = @"user";
static NSString* const kFiles = @"files";

-(id)init {
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        contacts = [[NSMutableArray alloc] init];
        com = [[Communicator alloc] initWithServer:kBaseURL AndUser:kLocations AndFile:kFiles];
    }
    return self;
}



-(User*)getPrimaryUser {
    return primaryUser;
}

+(id)getModel {
    static ShuqModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc] init];
    });
    return model;
}

-(BOOL)authenticateUser:(NSString*)username andPassword:(NSString*)password isNewUser:(BOOL)newUser{

    BOOL isValid;
    
    if ([username length] == 0) {
        return FALSE;
    }
    
    
    if(newUser) {
        NSArray* resp = [com addNewUserToServerWithUsername:username andPassword:password];
        if( resp != nil) {
            [self parseAndSetPrimaryUser:resp];
            return TRUE;
        }
    } else {
         NSArray* resp = [com getUserFromServerWithUsername:username andPassword:password];
        if( resp != nil) {
            [self getParsePrimaryUser:resp];
            return TRUE;
        }
    }
    return FALSE;
}

-(void)runUserMatches:(User*)user
{
    [com runUserMatches:user];
}

-(void)getMatchItems:(User*)user {
    NSArray* resp = [com getMatchItems:user];
    [_items removeAllObjects];
    if(resp != nil) {
        [self parseMatchingItems:resp];
    }
}

- (void) updateUser:(User*)user
{
    [com updateUser:user];
}


- (void) saveNewItemImage:(Item*)item
{
    [com saveNewItemImage:item andUser:primaryUser];
}

- (void) loadImage:(Item*)item {
    [com loadImage:item andUser:primaryUser];
}


-(void) parseAndSetPrimaryUser:(NSArray*) us
{
    if([us count] !=1) {
        return;
    }
    for (NSDictionary* item in us) {
        User* user = [[User alloc] initWithDictionary:item];
        primaryUser = user;
        //NSLog(@"%@", [primaryUser getUniqueID]);
    }
}
-(void) getParsePrimaryUser:(NSArray*) us
{
        User* user = [[User alloc] initWithDictionary:us];
        primaryUser = user;
    
       // NSLog(@"%@", [primaryUser getUniqueID]);
}

- (void) parseMatchingItems: (NSArray*) us {
    for (NSDictionary* user_item in us) {
        NSString* con = user_item[@"contact"];
        [self parseAndGetItems:user_item[@"userHas"] toArray:_items andContact:con];
    }
    NSLog(@"Load image");
}

- (void) parseAndGetItems:(NSArray*) it toArray:(NSMutableArray*) destinationArray andContact: (NSString*) con{
    for (NSDictionary* item in it) {
        Item* i = [[Item alloc] initWithDictionary:item];
        [destinationArray addObject:i];
        [contacts addObject:con];
    }

}

- (NSString*) getContact: (Item*) it {
    return [contacts objectAtIndex:[_items indexOfObject:it]];
}


@end
