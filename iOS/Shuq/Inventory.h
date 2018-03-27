//
//  Inventory.h
//  Shuq
//
//  Created by Joseph Min on 10/30/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "ItemList.h"
/**
 This class will contain all of the items that a user is offering.
 */
@interface Inventory : ItemList 

/**
 Create new inventory
 */
-(id)init;

@end
