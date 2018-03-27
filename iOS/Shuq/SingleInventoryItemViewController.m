//
//  SingleInventoryItemViewController.m
//  Shuq
//
//  Created by Joseph Min on 12/5/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "SingleInventoryItemViewController.h"
#import "ShuqModel.h"

@interface SingleInventoryItemViewController ()

@end

@implementation SingleInventoryItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _descriptionText.text = [_item getTagsStrings];
    _descriptionText.numberOfLines = 4;

    _valueText.text = [@"Value: $" stringByAppendingString:[[_item getValue] stringValue]];
    _navigationBar.title = @"Inventory Item";
    _nameText.text = [_item getName];
    if ([_item getImage] != nil) {
        _pictureImageView.image = [_item getImage];
    } else {
        _pictureImageView.image = [UIImage imageNamed:@"no-pic.png"];
    }
    _pictureImageView.layer.masksToBounds = YES;
    _pictureImageView.layer.cornerRadius = 10;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"deleteItem"]) {
        ShuqModel *model = [ShuqModel getModel];
        [[[model getPrimaryUser] getInventory] removeItem:_item];
        [model updateUser:[model getPrimaryUser]];
    }
}

@end
