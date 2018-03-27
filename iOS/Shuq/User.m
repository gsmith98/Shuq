//
//  User.m
//  Shuq
//
//  Created by Joseph Min on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "User.h"
#define safeSet(d,k,v) if (v) d[k] = v;

@implementation User

-(id)initWithUsername:(NSString*)u andWishlist:(Wishlist*)w andInventory:(Inventory*)i andSettings:(Settings*)s andLocation:(NSString*) l andPassword:(NSString*)p {
    self = [super init];
    
    if (self) {
        username = u;
        wishlist = w;
        inventory = i;
        settings = s;
        location = l;
        password = p;
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        
        //for(id key in dictionary)
          //  NSLog(@"key=%@ value=%@", key, [dictionary objectForKey:key]);
        
        username = dictionary[@"_id"];
        unid = username;
        location = dictionary[@"location"];
        password = dictionary[@"password"];
        contact = dictionary[@"contact"];
        wishlist = [[Wishlist alloc] initWithDictionary: dictionary[@"wishlist"]];
        inventory = [[Inventory alloc] initWithDictionary: dictionary[@"inventory"]];
        settings = [[Settings alloc] initWithDictionary: dictionary[@"settings"]];
    }
    return self;
}

-(NSString*) getUsername {
    return username;
}

-(Wishlist*) getWishlist {
    return wishlist;
}

-(Inventory*) getInventory {
    return inventory;
}

-(NSString*) getLocation {
    return location;
}

-(void) setLocation:(NSString*)loc {
    location = loc;
}

-(Boolean) checkPassword: (NSString*) p {
    return password == p;
}
- (NSDictionary*) toDictionary
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"_id", username);
    safeSet(jsonable, @"username", username);
    safeSet(jsonable, @"location", location);
    safeSet(jsonable, @"password", password);
    safeSet(jsonable, @"contact", contact );
    safeSet(jsonable, @"wishlist", [wishlist toDictionary]);
    safeSet(jsonable, @"inventory", [inventory toDictionary]);
    safeSet(jsonable, @"settings", [settings toDictionary]);
    
    return jsonable;
}
-(NSString*) getUniqueID {
    return unid;
}

-(NSString*) getContact {
    return contact;
}
-(void) setContact: (NSString*) con {
    contact = con;
}
-(NSString*) getPassword {
    return password;
}
- (NSDictionary*) toDictionarySimple
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"username", username);
    safeSet(jsonable, @"password", password);
    
    return jsonable;

}


@end
