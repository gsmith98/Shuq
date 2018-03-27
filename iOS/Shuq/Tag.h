//
//  Tag.h
//  Shuq
//
//  Created by Joshua Barza on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 
 */
@interface Tag : NSObject {
    /**
     Name of the tag
     */
    NSString* name;
}

/**
 create new tag
 @n name of the tag
 */
-(id)initWithName: (NSString*) n;


/**
 Returns the name of the tag
 @return tag name
 */
-(NSString*) getTagName;
@end
