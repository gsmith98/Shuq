//
//  Item.h
//  Shuq
//
//  Created by Elana Stroud on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"
/**
 This class represents an inventory or wishlist item.
 */
@interface Item : NSObject {
    /**
     Name of the item.
     */
    NSString* title;
    /**
     Tags of the item
     */
    NSMutableArray* tags;
    /**
     Ranking of the value of the item, from 1-4
     */
    NSNumber* value;
    /**
     Image of the item
     */
    UIImage* image;
    /**
     Image id of the image of the item
     */
    NSString* imageId;
}

/**
 Creates a new item
 @param name name of the item
 @param v the value of the item
 */
-(id)initWithName:(NSString *)name andValue: (NSNumber*) v;

/**
 Creates a new item based off of the JSON dictionary
 @param dictionay the JSON object
 */
- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
/**
 Returns name of item
 @return name
 */
-(NSString*) getName;
/** Returns value of item
 @return value
 */
-(NSNumber*) getValue;
/** Returns tags of item
 @return tags
 */
-(NSMutableArray*) getTags;
/** Returns comma seperated tags of item
 @return tags
 */
-(NSString*) getTagsStrings;
/**
 Add a tag to the item
 @param t name of tag to add
 */
-(void) addTag: (NSString *) t;
/**
 Set the image id of the object
 */
-(void) setImageId: (NSString*) iid;
/**
 Get the imageID of the object
 */
-(NSString *) getImageID;
/**
 Get the image of the object
 */
-(UIImage *) getImage;
/**
 Set the image of the object
 */
-(void) setImage: (UIImage*) i;
/**
 Turn the item into a dictionary
 */
- (NSDictionary*) toDictionary;


@end
