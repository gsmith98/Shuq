//
//  SingleWishlistItemViewController.h
//  Shuq
//
//  Created by Joseph Min on 12/5/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "SingleItemTemplateViewController.h"

@interface SingleWishlistItemViewController : SingleItemTemplateViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *valueText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property Item* item;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end
