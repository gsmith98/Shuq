//
//  Communicator.m
//  Shuq
//
//  Created by Joshua Barza on 12/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "Communicator.h"
#import "User.h"
#import "Item.h"

@implementation Communicator

-(id)initWithServer: (NSString*) ser AndUser:(NSString*) us AndFile: (NSString*) fil {
    self = [super init];
    if (self) {
        server = ser;
        userLoc = us;
        files= fil;
        reachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

-(NSArray*)updateUser:(User*)user{
    if(![self checkInternet]) {
        return nil;
    }
    if (!user ) {
        return nil;
    }
    
    NSString* locations = [server stringByAppendingPathComponent:userLoc];
    
    BOOL isExistingLocation = [user getUniqueID] != nil;
    
    NSURL* url = isExistingLocation ? [NSURL URLWithString:[locations stringByAppendingPathComponent:[user getUniqueID]]] :
    [NSURL URLWithString:locations]; //1
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = isExistingLocation ? @"PUT" : @"POST"; //2
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[user toDictionary] options:0 error:NULL]; //3
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; //4
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    __block NSArray* responseArray = [NSArray alloc];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (!error) {
            responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            dispatch_semaphore_signal(semaphore);
            
        } else {
            responseArray =nil;
            NSLog(@"ERROR");
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [dataTask resume];
     dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return responseArray;
}

-(void)runUserMatches:(User*)user{
    NSString* userAuth = [@"demoMakeMatches" stringByAppendingPathComponent:[user getUsername]];
    userAuth = [userAuth stringByAppendingString:@":"];
     userAuth = [userAuth stringByAppendingString:[user getUsername]];
     userAuth = [userAuth stringByAppendingString:@":"];
     userAuth = [userAuth stringByAppendingString:[user getPassword]];

    [self getRequest:userAuth];
}


-(NSArray* )getMatchItems:(User*)username{
    if(![self checkInternet]) {
        return nil;
    }
    
    NSString* userAuth = [[username getUsername] stringByAppendingString:@"Matches"];
    userAuth = [userAuth stringByAppendingString:@":"];
    userAuth = [userAuth stringByAppendingString:[username getUsername]];
    userAuth = [userAuth stringByAppendingString:@":"];
    userAuth = [userAuth stringByAppendingString:[username getPassword]];
    
    NSURL* url = [NSURL URLWithString:[server stringByAppendingPathComponent: userAuth]]; //1
    NSLog(@"urls: %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET"; //2
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"]; //3
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSArray* responseArray = [NSArray alloc];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        
        if (error == nil) {
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([responseBody rangeOfString:@"error"].location!= NSNotFound ||[responseBody rangeOfString:@"Taken"].location!= NSNotFound  ) {
                responseArray = nil;
                NSLog(@"Taken");
            }
            else if([responseBody rangeOfString:@"Free"].location != NSNotFound ) {
                responseArray = [NSArray alloc];
            }
            else {
                NSError *e;
                responseArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
            }
            dispatch_semaphore_signal(semaphore);
            
        } else {
            //error
            dispatch_semaphore_signal(semaphore);
        }
    }];
    
    
    [dataTask resume];
    
    //waiting for the call to be done
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return responseArray;
}


- (void) saveNewItemImage:(Item*)item andUser: (User*) us {
    if(![self checkInternet]) {
        return;
    }
    NSURL* url = [NSURL URLWithString:[server stringByAppendingPathComponent:@"files"]]; //1
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST"; //2
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"]; //3
    if([item getImage] != nil) {
        NSLog(@"Posting not nil photo");
    }
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSData* bytes = UIImagePNGRepresentation([item getImage]); //4
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            [item setImageId:responseDict[@"_id"]] ;
            [self updateUser:us];
        }
    }];
    [task resume];

}


- (void) loadImage:(Item*)item andUser: (User*) us{
    if(![self checkInternet]) {
        return;
    }
    
    NSString* userAuth = [[server stringByAppendingPathComponent:@"files"] stringByAppendingPathComponent:[item getImageID]];
    
    NSURL* url = [NSURL URLWithString:userAuth]; //1
    
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    NSLog(@"%@",[item getImageID]);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSessionDownloadTask* task = [session downloadTaskWithURL:url completionHandler:^(NSURL *fileLocation, NSURLResponse *response, NSError *error) { //2
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:fileLocation]; //3
            UIImage* image = [UIImage imageWithData:imageData];
            if (!image) {
                dispatch_semaphore_signal(semaphore);
                NSLog(@"unable to build image");
            }
            else {
                [item setImage:image];
                dispatch_semaphore_signal(semaphore);
            }
        }
    }];
    
    [task resume]; //4
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


-(BOOL) checkUsernameExists:(NSString*)username{
    NSString* userCheck = [@"userCheck" stringByAppendingPathComponent:username];
    
    userCheck = [userCheck stringByAppendingString:@":"];
    userCheck = [userCheck stringByAppendingString: username];
    userCheck = [userCheck stringByAppendingString:@":"];
    userCheck = [userCheck stringByAppendingString:@"pass"];

    
    
    NSArray* resp = [self getRequest:userCheck ];

    return resp == nil;
}


-(NSArray*)getUserFromServerWithUsername:(NSString*)user andPassword:(NSString*)pass{
    NSString* userAuth = [@"auth" stringByAppendingPathComponent:user];
    userAuth = [userAuth stringByAppendingString:@":"];
    userAuth = [userAuth stringByAppendingString:user];
    userAuth = [userAuth stringByAppendingString:@":"];
    userAuth = [userAuth stringByAppendingString:pass];
  
    
    NSArray* resp = [self getRequest:userAuth];
    return resp;
}


-(NSArray*)addNewUserToServerWithUsername:(NSString*)username andPassword:(NSString*)password{
    if ([self checkUsernameExists:username]) {
        return nil;
    }
    User *user = [[User alloc]initWithUsername:username andWishlist:[[Wishlist alloc]init] andInventory:[[Inventory alloc]init] andSettings:nil andLocation:@"11111" andPassword:password];
    

    NSArray* resp = [self updateUser:user];
    return resp;
}

- (NSArray*)getRequest: (NSString*) URLLoc{
    if(![self checkInternet]) {
        return nil;
    }
    
    NSURL* url = [NSURL URLWithString:[server stringByAppendingPathComponent: URLLoc]]; //1
    NSLog(@"urls: %@", url);
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET"; //2
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"]; //3
    
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSArray* responseArray = [NSArray alloc];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        
        if (error == nil) {
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([responseBody rangeOfString:@"error"].location!= NSNotFound ||[responseBody rangeOfString:@"Taken"].location!= NSNotFound  ) {
                responseArray = nil;
                NSLog(@"Taken");
            }
            else if([responseBody rangeOfString:@"Free"].location != NSNotFound ) {
                responseArray = [NSArray alloc];
            }
            else {
                
                responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            }
            dispatch_semaphore_signal(semaphore);
            
        } else {
            //error
            dispatch_semaphore_signal(semaphore);
        }
    }];
    
    
    [dataTask resume];
    
    //waiting for the call to be done
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return responseArray;
}

- (BOOL) checkInternet {
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return TRUE;
    }
    else {
        return FALSE;
    }

}

@end
