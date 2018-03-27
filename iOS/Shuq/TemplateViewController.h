//
//  TemplateViewController.h
//  Shuq
//
//  Created by Elana Stroud on 10/26/14.
//  Copyright (c) 2014 com.cape. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 The Class TemplateScreen. This class is extended by all other screens.
 */
@interface TemplateViewController : UIViewController <UITextFieldDelegate> {
    NSMutableArray *textFields;
}
-(void)dismissKeyboard;

@end
