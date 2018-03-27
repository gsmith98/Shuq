//
//  ViewController.h
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateViewController.h"
#import "ItemSwipeViewController.h"
#import "ShuqModel.h"

/**
 The Class LoginScreen. This class represents the screen that handles login, and can move to related screens as shown in the GUI sketches.
 */
@interface NewUserViewController : TemplateViewController <UITextFieldDelegate> {
    /**
     The model for the app
     */
    ShuqModel* model;
    
    int FRAME_SIZE;
    double ANIMATION_SPEED;
    int JUMP;
    int BIG_JUMP;
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *newuserTextField;
@property (strong, nonatomic) IBOutlet UITextField *newpassTextField;
@property (strong, nonatomic) IBOutlet UITextField *newcontactTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIButton *createAccountButton;


@end
