//
//  AboutController.h
//  JobShout
//
//  Created by Liam Flynn on 16/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate> {
 
    IBOutlet UIButton *button;
}

@property(nonatomic, strong) UIButton *button;

- (IBAction)contact:(id)sender;

@end
