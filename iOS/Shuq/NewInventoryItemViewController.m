//
//  NewInventoryItemViewController.m
//  Shuq
//
//  Created by Joseph Min on 11/15/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "NewInventoryItemViewController.h"
#import "InventoryViewController.h"
#import "Inventory.h"
#import "Item.h"
#import "ShuqModel.h"

@interface NewInventoryItemViewController ()

@end

@implementation NewInventoryItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textFields = [[NSMutableArray alloc]initWithObjects:_descriptionTextField, _nameTextField, _valueTextField, nil];
    
    [_addItemButton addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchDown];
    
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addItem:(id)sender {
    if(_nameTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Item cannot have empty name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"backToInventory"]){
        
        NSNumber* num = [NSNumber numberWithInteger:[_valueTextField.text integerValue]];
        Item* newInventoryItem = [[Item alloc] initWithName:_nameTextField.text andValue:num];
        //Add tags
        [super addTags:_descriptionTextField.text toItem:newInventoryItem];

        //Set item photo
        if(self.photo != nil) {
            [newInventoryItem setImage: self.photo];
        } else {
            [newInventoryItem setImage:[UIImage imageNamed:@"no-pic.png"]];
        }
        
        Inventory* inventory = [[[ShuqModel getModel] getPrimaryUser] getInventory];
        [inventory addItem:newInventoryItem];
        ShuqModel *model = [ShuqModel getModel];
        //Post Image
        if(self.photo != nil) {
            [model saveNewItemImage:newInventoryItem];
        }
        else {
            //PUT the primary user
            [model updateUser:[model getPrimaryUser]];
        }
    }
}

- (IBAction)TakePhoto:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSMutableArray* list = [[NSMutableArray alloc] init];
        [list addObject:@"hat.png"];
        [list addObject:@"iphone.png"];
        [list addObject:@"flask.png"];
        [list addObject:@"glasses.png"];
        int ind = arc4random() % 4;
        
        UIImage* fileimage = [UIImage imageNamed:[list objectAtIndex:ind]];
        self.photo =fileimage;
        self.imageView.image = fileimage;
        
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.photo = chosenImage;
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
