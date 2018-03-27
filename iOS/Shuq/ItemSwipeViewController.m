//
//  ItemSwipeViewController.m
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import "ItemSwipeViewController.h"
#import "Item.h"
#import "InventoryViewController.h"
#import "WishlistTableViewController.h"
#import "ShuqModel.h"
#import <MessageUI/MessageUI.h>


@interface ItemSwipeViewController ()

@end

@implementation ItemSwipeViewController

@synthesize itemName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        enlarged = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _itemIndex = 0;
    _itemDesc.textColor = [UIColor whiteColor];
    
    [self loadItemsArray];
    [self loadItemsImageView];
    [self loadGestures];
    
    
    [self.view addSubview:_itemView];
}

- (void) handleSwipe:(UISwipeGestureRecognizer *) swipe {
    
    //loops items
    ShuqModel *model = [ShuqModel getModel];
    /**/
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        _itemIndex = (_itemIndex + 1) % [model.items count];


    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        if (_itemIndex == 0) {
            _itemIndex = [model.items count];

        }
        _itemIndex = (_itemIndex - 1) % [model.items count];


    }
    
    [self setItem];
}

-(void) loadItemsArray {
    
    ShuqModel *model = [ShuqModel getModel];
    [model runUserMatches:[model getPrimaryUser] ];
    [model getMatchItems:[model getPrimaryUser] ];
    
    NSString *numMatches = [NSString stringWithFormat:@"%d", (int)_itemIndex + 1];
    numMatches = [numMatches stringByAppendingString:@"/"];
    numMatches = [numMatches stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[model.items count]]];
    
    [_numMatchesLabel setText:numMatches];
    
   }

-(void) setItem {
    ShuqModel *model = [ShuqModel getModel];
    if([model.items count] ==0){
        UIImage *no_match = [UIImage imageNamed:@"no-matches.png"];
        [_itemView setImage:no_match];
        [itemName setText:@""];
        [_itemDesc setText:@""];
        NSString *numMatches = [NSString stringWithFormat:@"%d", (int)_itemIndex];
        numMatches = [numMatches stringByAppendingString:@"/"];
        numMatches = [numMatches stringByAppendingString:[NSString stringWithFormat:@"%d", (int)[model.items count]]];
        [_itemVal setText:@""];
        [_numMatchesLabel setText:numMatches];
        return;
    }
    Item *item =[model.items objectAtIndex:_itemIndex];
    
    if([item getImage] == nil) {
        [_itemView setImage:[UIImage imageNamed:@"no-pic"]];
    } else {
        [_itemView setImage: [item getImage]];
    }
    
    [itemName setText:[item getName]];
    [_itemDesc setText:[@"Tags: " stringByAppendingString:[item getTagsStrings]]];
    [_itemVal setText:[@"$" stringByAppendingString:[[item getValue] stringValue]]];

    
    NSString *numMatches = [NSString stringWithFormat:@"%d", _itemIndex + 1];
    numMatches = [numMatches stringByAppendingString:@"/"];
    numMatches = [numMatches stringByAppendingString:[NSString stringWithFormat:@"%d", [model.items count]]];
    
    [_numMatchesLabel setText:numMatches];
}

-(void) loadItemsImageView {
    _itemView = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                              [UIScreen mainScreen].bounds.size.width/6 + 7,
                                                              [UIScreen mainScreen].bounds.size.height/4, 200, 200)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlarge)];
    
    singleTap.numberOfTapsRequired = 1;
    [_itemView setUserInteractionEnabled:YES];
    [_itemView addGestureRecognizer:singleTap];

    
    [self setItem];
    
    _itemView.layer.masksToBounds = YES;
    _itemView.layer.cornerRadius = 10;
    
}

-(void)loadGestures {
    [_itemView setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [_itemView addGestureRecognizer:swipeLeft];
    [_itemView addGestureRecognizer:swipeRight];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)MatchButton:(id)sender {
    ShuqModel *model = [ShuqModel getModel];
    if ([model.items count] !=0) {
        Item* i = [model.items objectAtIndex:_itemIndex];
        NSString* con = [model getContact:i];
        [self showSMS:[i getName] andReciepient:con];
        NSLog(@"Item name: %@ Number: %@",[i getName], con);
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS:(NSString*)iN andReciepient: (NSString*) number {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSMutableArray *itemTrade = [[[[ShuqModel getModel]getPrimaryUser]getInventory] getItems];
    NSString *itemWant = [[itemTrade objectAtIndex:0]getName];
    
                           
    NSString *message = [NSString stringWithFormat:@"Hey! I'm interested in trading for your %@! I have a %@ that you might be interested in.", iN, itemWant];

    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    messageController.recipients = [NSArray arrayWithObjects:number, nil];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void) enlarge {
    if(!enlarged) {
        [_itemView setFrame:CGRectMake(0, 0,                       [UIScreen mainScreen].bounds.size.width,                       [UIScreen mainScreen].bounds.size.width)];
        enlarged = TRUE;
    }
    else {
        [_itemView setFrame: CGRectMake(                      [UIScreen mainScreen].bounds.size.width/6 + 7,
                                       [UIScreen mainScreen].bounds.size.height/4, 200, 200)];
        enlarged = FALSE;
    }
}
- (IBAction)refresh:(id)sender {
    _itemIndex = 0;
    [self loadItemsArray];
    [self setItem];
}
@end
