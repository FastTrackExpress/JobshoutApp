//
//  AboutController.m
//  JobShout
//
//  Created by Liam Flynn on 16/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize button;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.button = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    //return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)contact:(id)sender{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.navigationBar.barStyle = UIBarStyleBlack;
    controller.navigationBar.tintColor = [UIColor darkGrayColor];
    controller.mailComposeDelegate = self;
    
    NSArray* toArray = [NSArray arrayWithObjects:@"contact@jobshout.com",nil];
    [controller setToRecipients:toArray];
    [controller setSubject:@"Jobshout App"];
    
    if (controller) {
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    if (result == MFMailComposeResultSent) {
        DebugLog(@"Contact email sent");
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
