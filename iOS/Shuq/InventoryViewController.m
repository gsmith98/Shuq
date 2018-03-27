//
//  InventoryViewController.m
//  Shuq
//
//  Created by Joseph Min on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "InventoryViewController.h"
#import "SingleInventoryItemViewController.h"
#import "Item.h"
#import "Inventory.h"
#import "User.h"

@interface InventoryViewController ()

@end

@implementation InventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemList = [[[ShuqModel getModel] getPrimaryUser] getInventory];
    items = [itemList getItems];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set item based on which cell is selected by user
    _toSend = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier: @"cellSelected" sender: self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"cellSelected"]){
        SingleInventoryItemViewController *destViewController = segue.destinationViewController;
        destViewController.item = _toSend;
    }
}

@end
