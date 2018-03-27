//
//  Settings.m
//  Shuq
//
//  Created by Joshua Barza on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "Settings.h"
#define safeSet(d,k,v) if (v) d[k] = v;

@implementation Settings
-(id)init {
    self = [super init];
    if (self) {
        privacy = @"1";
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        privacy = dictionary[@"privacy"];
    }
    return self;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"privacy", privacy);

    return jsonable;
}

@end
