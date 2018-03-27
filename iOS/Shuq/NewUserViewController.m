//
//  ViewController.m
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    FRAME_SIZE = 45;
    ANIMATION_SPEED = .3;
    JUMP = 70;
    BIG_JUMP = 135;
    UIColor *placeholderColor = [UIColor colorWithRed:141/255.0 green:150/255.0 blue:164/255.0 alpha:1];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    textFields = [[NSMutableArray alloc]initWithObjects:_newuserTextField, _newpassTextField, _newcontactTextField, _locationField, nil];

    
    _newuserTextField.delegate = self;
    _newpassTextField.delegate = self;
    _newcontactTextField.delegate = self;
    _locationField.delegate = self;

    //formatting text fields
    CGRect frameRect = _newuserTextField.frame;
    frameRect.size.height = FRAME_SIZE;
    _newuserTextField.frame = frameRect;
    _newuserTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    
    frameRect = _newpassTextField.frame;
    frameRect.size.height = FRAME_SIZE;
    _newpassTextField.frame = frameRect;
    _newpassTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    frameRect = _newcontactTextField.frame;
    frameRect.size.height = FRAME_SIZE;
    _newcontactTextField.frame = frameRect;
    _newcontactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"555-123-4567" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    frameRect = _locationField.frame;
    frameRect.size.height = FRAME_SIZE;
    _locationField.frame = frameRect;
    _locationField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"enter your zipcode" attributes:@{NSForegroundColorAttributeName: placeholderColor}];


    
    [_continueButton addTarget:self action:@selector(checkUsername) forControlEvents:UIControlEventTouchDown];
    
    [_createAccountButton addTarget:self action:@selector(addLocation) forControlEvents:UIControlEventTouchDown];
    
    model = [ShuqModel getModel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkUsername {
    UIAlertView *alert;
    NSString* username = _newuserTextField.text;
    NSString* password = _newpassTextField.text;
    
    NSString *trimContact = [_newcontactTextField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];

    
    username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0) {
        alert = [[UIAlertView alloc]initWithTitle:@"Invalid Username" message:@"Cannot have a blank username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(trimContact.length != 10) {
        alert = [[UIAlertView alloc]initWithTitle:@"Invalid Contact" message:@"Phone number must be 10 digits long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    if ([model authenticateUser:username andPassword: password isNewUser:TRUE]) {
        [[model getPrimaryUser] setContact:trimContact];
    } else {
        alert = [[UIAlertView alloc]initWithTitle:@"Invalid Username" message:@"Username already exists. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


-(void)dismissKeyboard {
    [_locationField resignFirstResponder];
    [super dismissKeyboard];
}

-(void)addLocation {
    NSString *loc = _locationField.text;
    
    if(_locationField.text.length != 5) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Location" message:@"Zipcode must be 5-digits longs." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[model getPrimaryUser] setLocation:loc];
    [model updateUser:[model getPrimaryUser]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = textField.text;
    
   
    if(textField.text.length == 3) {
        newString =[textField.text stringByReplacingCharactersInRange:range withString:@"-"];
    } else if(textField.text.length == 7) {
        newString =[textField.text stringByReplacingCharactersInRange:range withString:@"-"];
    }
    [self updateTextLabelsWithText: newString];
    
   
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    
    if([_newcontactTextField isEditing]) {
        if(string.length > 11) {
            string = [string substringToIndex:11];
        }
        [_newcontactTextField setText:string];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
