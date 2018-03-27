//
//  AddItemTemplateViewController.m
//  Shuq
//
//  Created by Elana Stroud on 12/14/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "AddItemTemplateViewController.h"
#import "Item.h"

@interface AddItemTemplateViewController ()

@end

@implementation AddItemTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addTags: (NSString*) tags toItem: (Item*) i {
    NSArray* t = [tags componentsSeparatedByString:@","];
    for (int n=0; n<[t count]; n++) {
        [i addTag: [t objectAtIndex:n]];
    }
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
