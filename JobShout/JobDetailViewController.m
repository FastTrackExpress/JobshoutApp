//
//  JobDetailViewController.m
//  JobShout
//
//  Created by Liam Flynn on 02/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "JobDetailViewController.h"

@interface JobDetailViewController()
    
@property(nonatomic, strong) IBOutlet UITextView *jobTitle;
@property(nonatomic, strong) IBOutlet UIWebView *formattedJobDescription;
@property(nonatomic, strong) IBOutlet UIButton *emailButton;

@end
    
@implementation JobDetailViewController

@synthesize job, jobTitle, formattedJobDescription, emailButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Do any additional setup after loading the view from its nib.
    jobTitle.text = job.title;
    
    NSString *formattedDescriptionHTML = [NSString stringWithFormat:@"<html> <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />"
                                   "<head> \n"
                                   "<style type=\"text/css\"> \n"
                                   "body {font-family: \"%@\"; font-size: %@;}\n"
                                   "</style> \n"
                                   "</head> \n"
                                   "<body>%@</body> \n"
                                   "</html>", @"helvetica neue", [NSNumber numberWithInt:15], job.description];
    
    [formattedJobDescription loadHTMLString:formattedDescriptionHTML baseURL:[NSURL URLWithString:@""]];
}

- (IBAction)sendButtonPressed:(id)sender{
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.navigationBar.barStyle = UIBarStyleBlack;
    controller.mailComposeDelegate = self;
    
    if(sender == emailAgentButton){
       
        
        NSArray *toArray = [NSArray arrayWithObjects:job.contactEmail,nil];
        [controller setToRecipients:toArray];
        
        NSString *subject = [[NSString alloc] initWithFormat:@"Ref: %@", job.referenceCode];
        [controller setSubject:subject];
        
        NSString *body = [[NSString alloc] initWithFormat:@"\n\n\n\n\n\n Title: %@ \n Agency Reference: %@ \n\n Jobshout for iPhone, iPad and iPod Touch.", job.title, job.referenceCode];
        [controller setMessageBody:body isHTML:NO];
    }
    else if(sender == emailFriendButton){
        
        NSString *subject = [[NSString alloc] initWithFormat:@"%@", job.title];
        [controller setSubject:subject];
        
        NSString *body = [[NSString alloc] initWithFormat:@"I think this vacancy may be of interest to you: \n\n%@ \n\n Link: %@ \n\n Agent: %@ \n Agency Reference: %@ \n\n\n Jobshout for iPhone, iPad and iPod Touch.", job.title, job.link, job.contactEmail, job.referenceCode];
        [controller setMessageBody:body isHTML:NO];
    }
    
    if (controller){
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload{
    // Release any retained subviews of the main view.
    self.jobTitle = nil;
    self.formattedJobDescription = nil;
    self.emailButton = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
