//
//  Item.m
//  Shuq
//
//  Created by Elana Stroud on 10/29/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "ShuqModel.h"
#import "Item.h"

@implementation Item

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

-(id)initWithName:(NSString*)name andValue: (NSNumber*) v{
    self = [super init];
    
    if (self) {
        title = name;
        value = v;
        tags = [[NSMutableArray alloc] init];
    }
    return self;

}

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    
    if (self) {
        ShuqModel *model = [ShuqModel getModel];
        tags = [[NSMutableArray alloc] init];
        
        title = dictionary[@"name"];
        imageId = dictionary[@"imageId"];
        value = dictionary[@"value"];
        if(imageId != nil) {
            //load image
            [model loadImage:self];
        }
        
        NSMutableArray* tagJSON = dictionary[@"tags"];
        for(NSUInteger n=0; n< [tagJSON count]; n++)
        {
            [self addTag:[tagJSON objectAtIndex:n]];
        }
        
    }
    return self;
}


-(NSString*) getName {
    return title;
}

-(NSNumber*) getValue {
    return value;
}

-(NSMutableArray*) getTags {
    return tags;
}
-(NSString*) getTagsStrings {
    NSString* result =@"";
    for (int i=0; i< [tags count]; i++) {
        result =[result stringByAppendingString:[[tags objectAtIndex:i]getTagName]];
        if (i!= [tags count]-1) {
            result = [result stringByAppendingString:@", "];
        }
    }
    return result;
}
-(void) addTag: (NSString *) t{
    Tag* tag = [[Tag alloc] initWithName:t];
    [tags addObject:tag];
}
-(void) setImageId: (NSString*) iid{
    imageId= iid;
    //NSLog(@"setting: %@", imageId);
}

-(NSString *) getImageID {
    //NSLog(@"getting: %@", imageId);
    return imageId;
}

-(UIImage *) getImage {
    return image;
}

-(void) setImage: (UIImage*) i {
    image = i;
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* toReturn = [NSMutableDictionary dictionary];
    toReturn[@"name"] = [self getName];
    if([self getImageID] != nil) {
        toReturn[@"imageId"] = [self getImageID];
    }
    
    toReturn[@"value"]= [self getValue];
    
    NSMutableArray* tagList = [self getTags];
    NSMutableArray* tagJSON =[[NSMutableArray alloc] init];
    for(NSUInteger n = 0; n < [tagList count]; n++) {
        Tag* t= [tagList objectAtIndex:n];
        [tagJSON addObject: [t getTagName]];
    }
    toReturn[@"tags"] = tagJSON;
    return toReturn;
}




@end
