//
//  JobDetailViewController.h
//  JobShout
//
//  Created by Liam Flynn on 02/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "RssItem.h"


@interface JobDetailViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    
    IBOutlet UITextView *jobTitle;
    IBOutlet UIWebView *formattedJobDescription;
    IBOutlet UIButton *emailAgentButton;
    IBOutlet UIButton *emailFriendButton;
    
    RssItem* job;
}

@property (nonatomic, strong) RssItem* job;

@end
