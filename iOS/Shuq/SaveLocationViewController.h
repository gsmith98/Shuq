//
//  SaveLocationViewController.h
//  Shuq
//
//  Created by Elana Stroud on 12/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "TemplateNavViewController.h"
#import "ShuqModel.h"

@interface SaveLocationViewController : TemplateNavViewController {
    ShuqModel *model;
}

-(IBAction)saveLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton* saveLocationButton;
@property(weak, nonatomic) IBOutlet UITextField *locField;

@end
