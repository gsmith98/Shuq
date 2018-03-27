//
//  ShuqSeverConnectionTest.m
//  Shuq
//
//  Created by Joshua Barza on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Item.h"
#import "User.h"
#import "Wishlist.h"
#import "Inventory.h"
#import "ShuqModel.h"

@interface ShuqSeverConnectionTest : XCTestCase

@end

@implementation ShuqSeverConnectionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnection
{
    ShuqModel*  model = [[ShuqModel alloc] init];
    User* user = [model getPrimaryUser];
    NSUInteger num = 1;
    Item *i1 = [[Item alloc] initWithName:@"iPhone Charger" andPath:@"iphone.png" andDesc:@"Brand new, just bought from Amazon. Comes with wall attachment." andValue: &num];
    [i1 addTag:@"food"];
    [i1 addTag:@"electronics"];
    Item *i2 = [[Item alloc] initWithName:@"Flask" andPath:@"flask.png" andDesc:@"Only used once. Tastes best with whisky." andValue: &num];
    [i2 addTag: @"table"];
    [[user getInventory] addItem:i1];
    [[user getWishlist] addItem:i2];
    
    [model persist:user];
}

- (void) testGetConnection
{
    NSURL* url = [NSURL URLWithString:@"http://localhost:3000"]; //1
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET"; //2
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"]; //3
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            XCTAssertTrue(true, @"Connection should be established");
            //[self parseAndAddLocations:responseArray toArray:self.objects]; //7
        }
        else {
            XCTAssertTrue(false, @"Connection should be established");
        }
    }];
    
    [dataTask resume]; //8
}

@end
