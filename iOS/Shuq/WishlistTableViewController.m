//
//  WishlistTableViewController.m
//  Shuq
//
//  Created by Joseph Min on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "WishlistTableViewController.h"
#import "SingleWishlistItemViewController.h"

@interface WishlistTableViewController ()

@end

@implementation WishlistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemList = [[[ShuqModel getModel] getPrimaryUser] getWishlist];
    items = [itemList getItems];

    [_tableView setDataSource:self];
    [_tableView setDelegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Value Selected by user
    NSLog(@"in here?");
    _toSend = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"cellSelected" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"cellSelected"]){
        SingleWishlistItemViewController *destViewController = segue.destinationViewController;
        destViewController.item = _toSend;
    }
}

@end
