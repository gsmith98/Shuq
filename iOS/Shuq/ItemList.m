//
//  ItemList.m
//  Shuq
//
//  Created by Joseph Min on 12/14/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "ItemList.h"
#import "ShuqModel.h"
#define safeSet(d,k,v) if (v) d[k] = v;

@implementation ItemList
-(id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self)
    {
        items = [[NSMutableArray alloc] init];
        NSMutableArray* itemJSON = dictionary[@"items"];
        for (NSUInteger i=0; i< [itemJSON count]; i++)
        {
            Item* it = [[Item alloc] initWithDictionary:[itemJSON objectAtIndex:i]];
            [self addItem:it];
        }
    }
    return self;
}


-(NSMutableArray*) getItems {
    return items;
}

-(void) addItem:(Item*)i {
    [items addObject:i];
}

-(Item*) getItem:(NSUInteger*)i {
    if ([items objectAtIndex:*i] != nil) {
        return [items objectAtIndex:*i];
    }
    return nil;
}

-(void) removeItem:(Item*)i {
    if ([items indexOfObject:i] != -1) {
        [items removeObject:i];
    }
}
- (NSDictionary*) toDictionary
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    NSMutableArray* itemJSON =[[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < [items count]; i++) {
        NSMutableDictionary* item = [[items objectAtIndex:i] toDictionary];
        [itemJSON addObject:item];
    }
    safeSet(jsonable, @"items", itemJSON);
    return jsonable;
}


@end
