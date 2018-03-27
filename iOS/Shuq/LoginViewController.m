//
//  ViewController.m
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "LoginViewController.h"
#import "Inventory.h"
#import "ShuqModel.h"
#import "Item.h"

@interface LoginViewController () {
}



@end

@implementation LoginViewController

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
    
    textFields = [[NSMutableArray alloc]initWithObjects:_usernameTextField, _passwordTextField, nil];
    
    _usernameTextField.delegate = self;
    _passwordTextField.delegate = self;
    
    
    //formatting text fields
    CGRect frameRect = _usernameTextField.frame;
    frameRect.size.height = FRAME_SIZE;
    _usernameTextField.frame = frameRect;
    _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"username" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    
    frameRect = _passwordTextField.frame;
    frameRect.size.height = FRAME_SIZE;
    _passwordTextField.frame = frameRect;
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: placeholderColor}];
    
    [_aboutButton addTarget:self action:@selector(showAbout) forControlEvents:UIControlEventTouchUpInside];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)attemptLogin:(id)sender {
    model = [ShuqModel getModel];
    NSString* username = _usernameTextField.text;
    NSString* password = _passwordTextField.text;
    if ([model authenticateUser:username andPassword: password isNewUser:FALSE]) {
        
        Inventory* inventory = [[[ShuqModel getModel] getPrimaryUser] getInventory];
        [model runUserMatches:username];
        
        [self performSegueWithIdentifier:@"loginSuccess" sender:sender];
//        ItemSwipeViewController *isvc = [[ItemSwipeViewController alloc] init];
//        [self presentModalViewController:isvc animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Failed to Login" message: @"Invalid username or password" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"newUser"]){
        ItemSwipeViewController *controller = (ItemSwipeViewController *    )segue.destinationViewController;
        controller.model = model;
    }
}

-(void)showAbout {
    UIAlertView *about = [[UIAlertView alloc]initWithTitle:@"About this App" message:@"Shuq is a mobile trading post, allowing users to trade what they have for what they want. If you have an account, you can login here. Otherwise, hit the new user button to get started!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [about show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:ANIMATION_SPEED];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _usernameTextField.frame = CGRectMake(_usernameTextField.frame.origin.x, (_usernameTextField.frame.origin.y - JUMP), _usernameTextField.frame.size.width, _usernameTextField.frame.size.height);
        _passwordTextField.frame = CGRectMake(_passwordTextField.frame.origin.x, (_passwordTextField.frame.origin.y - JUMP), _passwordTextField.frame.size.width, _passwordTextField.frame.size.height);
        _loginButton.frame = CGRectMake(_loginButton.frame.origin.x, (_loginButton.frame.origin.y - JUMP), _loginButton.frame.size.width, _loginButton.frame.size.height);
        _logo.frame = CGRectMake(_logo.frame.origin.x, (_logo.frame.origin.y - JUMP), _logo.frame.size.width, _logo.frame.size.height);
        _newuserButton.frame = CGRectMake(_newuserButton.frame.origin.x, (_newuserButton.frame.origin.y - (BIG_JUMP)), _newuserButton.frame.size.width, _newuserButton.frame.size.height);
        _aboutButton.frame = CGRectMake(_aboutButton.frame.origin.x, (_aboutButton.frame.origin.y - BIG_JUMP), _aboutButton.frame.size.width, _aboutButton.frame.size.height);
        
        [UIView commitAnimations];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:ANIMATION_SPEED];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _usernameTextField.frame = CGRectMake(_usernameTextField.frame.origin.x, (_usernameTextField.frame.origin.y + JUMP), _usernameTextField.frame.size.width, _usernameTextField.frame.size.height);
    
        _passwordTextField.frame = CGRectMake(_passwordTextField.frame.origin.x, (_passwordTextField.frame.origin.y + JUMP), _passwordTextField.frame.size.width, _passwordTextField.frame.size.height);
    
        _loginButton.frame = CGRectMake(_loginButton.frame.origin.x, (_loginButton.frame.origin.y + JUMP), _loginButton.frame.size.width, _loginButton.frame.size.height);
    
        _logo.frame = CGRectMake(_logo.frame.origin.x, (_logo.frame.origin.y + JUMP), _logo.frame.size.width, _logo.frame.size.height);
    
        _newuserButton.frame = CGRectMake(_newuserButton.frame.origin.x, (_newuserButton.frame.origin.y + (BIG_JUMP)), _newuserButton.frame.size.width, _newuserButton.frame.size.height);
    
        _aboutButton.frame = CGRectMake(_aboutButton.frame.origin.x, (_aboutButton.frame.origin.y + BIG_JUMP), _aboutButton.frame.size.width, _aboutButton.frame.size.height);
    
    
        [UIView commitAnimations];
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
