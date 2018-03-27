//
//  ItemSwipeViewController.h
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "TemplateNavViewController.h"
#import "ShuqModel.h"

/**
 The Class SwipeScreen. This class represents the screen that handles the main swiping page, and can move to related screens as shown in the GUI sketches.
 */
@interface ItemSwipeViewController : TemplateNavViewController {
    BOOL enlarged;
}

/**
 The view for the image associated with the item
 */
@property UIImageView* itemView;
/**
 the list of items that the user will be swiping through
 */
@property NSMutableArray* items;
/**
 Index of the item currently being displayed
 */
@property NSInteger itemIndex;
/**
 The model
 */
@property ShuqModel* model;
/**
 View of the name of the item currently being displayed.
 */
@property (weak, nonatomic) IBOutlet UILabel* itemName;
/**
 View of the description of the item currently being displayed.
 */
@property (weak, nonatomic) IBOutlet UITextView* itemDesc;
@property (weak, nonatomic) IBOutlet UILabel *numMatchesLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemVal;

/*Called to refresh the front page*/
- (IBAction)refresh:(id)sender;

/**
 Called when match button is pressed
 */
- (IBAction)MatchButton:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender;
/**
 Called after the user sends a text message
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result;

/**
 Opens up a text message to send to the user
 @param itemName name of the item
 @param the number to send it to
 */
- (void)showSMS:(NSString*)itemName andReciepient: (NSString*) number;

@end
