//
//  InventoryViewController.h
//  Shuq
//
//  Created by Joseph Min on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShuqModel.h"
#import "ListTableTableViewController.h"

@interface InventoryViewController : ListTableTableViewController
{

}

/**
 The model
 */
@property ShuqModel* model;

/**
 An item to view as a single item
 */
@property Item* toSend;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
