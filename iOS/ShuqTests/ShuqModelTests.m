//
//  ShuqModelTests.m
//  Shuq
//
//  Created by Joshua Barza on 11/1/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Item.h"
#import "User.h"
#import "Wishlist.h"
#import "Inventory.h"
#import "ShuqModel.h"

/**
    This files contains the methods to Unit Test the Shuq Model
 */
@interface ShuqModelTests : XCTestCase

@end

@implementation ShuqModelTests

/**
    Sets up the tests
 */
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

/**
  Called after tests have been run
 */
- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
    Unit test for Item Class
 */
- (void)testItem
{
    NSUInteger num = 1;
    Item *i1 = [[Item alloc] initWithName:@"iPhone Charger" andPath:@"iphone.png" andDesc:@"Brand new, just bought from Amazon. Comes with wall attachment." andValue: &num];
    XCTAssertEqual(@"iPhone Charger", [i1 getName], @"Names should be equal");
    XCTAssertEqual(@"iphone.png", [i1 getPath], @"Path to image should be equal");
    XCTAssertEqual(@"Brand new, just bought from Amazon. Comes with wall attachment.", [i1 getDesc], @"Descriptions should be equal");
}

/**
 Unit test for User Class
 */
- (void)testUser
{
    User *u1 = [[User alloc] initWithUsername:@"Jcool98" andWishlist:[[Wishlist alloc] init] andInventory:[[Inventory alloc] init] andSettings:0 andLocation:@"Baltimore" andPassword:@"OOSEisLove"];
    XCTAssertEqual(@"Jcool98", [u1 getUsername],@"Usernames should be equal");
    XCTAssertEqual(@"Baltimore", [u1 getLocation], @"Locations Should be equal");
    XCTAssertEqual(true, [u1 checkPassword:@"OOSEisLove"], @"CheckingPassword");
}

/**
 Unit test for Wishlist Class
 */
- (void) testWishlist
{
    NSUInteger num = 1;
    Item *i1 = [[Item alloc] initWithName:@"iPhone Charger" andPath:@"iphone.png" andDesc:@"Brand new, just bought from Amazon. Comes with wall attachment." andValue: &num];
    Item *i2 = [[Item alloc] initWithName:@"Flask" andPath:@"flask.png" andDesc:@"Only used once. Tastes best with whisky." andValue: &num];

    Wishlist *w = [[Wishlist alloc] init];
    [w addItem:i1];
    [w addItem:i2];
    
    
    XCTAssertEqual(i2, [w getItem:&num], @"Testing getItem method");
    XCTAssertEqual(i2, [w removeItem:&num], @"Testing RemoveItem method");
    
    NSMutableArray* items = [w getWishlistItems];
    
    XCTAssertEqual(1, [items count], @"Testing Size reduction after remove");
    
    [w emptyWishlist];
    items = [w getWishlistItems];
    XCTAssertEqual(0, [items count], @"Testing Size reduction after empty");
}

/**
 Unit test for Inventory Class
 */
- (void) testInventory
{
        NSUInteger num = 1;
    Item *i1 = [[Item alloc] initWithName:@"iPhone Charger" andPath:@"iphone.png" andDesc:@"Brand new, just bought from Amazon. Comes with wall attachment." andValue: &num];
    Item *i2 = [[Item alloc] initWithName:@"Flask" andPath:@"flask.png" andDesc:@"Only used once. Tastes best with whisky." andValue: &num];
    
    Inventory *inv = [[Inventory alloc] init];
    [inv addItem:i1];
    [inv addItem:i2];
    
    
    XCTAssertEqual(i2, [inv getItem:&num], @"Testing getItem method");
    XCTAssertEqual(i2, [inv removeItem:&num], @"Testing RemoveItem method");
    
    NSMutableArray* items = [inv getInventoryItems];
    
    XCTAssertEqual(1, [items count], @"Testing Size reduction after remove");
    
}

/**
 Unit test for ShuqModel Class
 */
- (void) testShuqModel
{
    ShuqModel *model = [[ShuqModel alloc]init];
    NSMutableArray* users = [model getUsers];
    
    XCTAssertEqual(0, [users count], @"Testing getUsers");
}
@end
