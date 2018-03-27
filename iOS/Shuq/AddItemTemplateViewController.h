//
//  AddItemTemplateViewController.h
//  Shuq
//
//  Created by Elana Stroud on 12/14/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "TemplateNavViewController.h"
#import "Item.h"

@interface AddItemTemplateViewController : TemplateNavViewController

/**
    Add tags based on comma spertated string to the item
 @param tags the tags to add
 @param i the item to add tags to
 */
-(void) addTags: (NSString*) tags toItem: (Item*) i;

@end
