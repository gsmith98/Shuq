//
//  SaveLocationViewController.m
//  Shuq
//
//  Created by Elana Stroud on 12/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "SaveLocationViewController.h"

@interface SaveLocationViewController ()

@end

@implementation SaveLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_saveLocationButton addTarget:self action:@selector(saveLocation:) forControlEvents:UIControlEventTouchDown];
    
    model = [ShuqModel getModel];    
    [_locField setText:[[model getPrimaryUser]getLocation]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)saveLocation:(id)sender {
    NSString *loc = _locField.text;
    
    if(_locField.text.length != 5) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Location" message:@"Zipcode must be 5-digits longs." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[model getPrimaryUser] setLocation:loc];
    [model updateUser:[model getPrimaryUser]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
