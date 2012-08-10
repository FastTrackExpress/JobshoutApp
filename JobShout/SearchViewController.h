//
//  FirstViewController.h
//  JobShout
//
//  Created by Liam Flynn on 23/06/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPickerViewController.h"
#import "JobServerRequst.h"


@interface SearchViewController : UIViewController<UITextFieldDelegate, SearchPickerDelegate> {
    
    SearchPickerViewController *multipurposePicker;
    
    IBOutlet UITextField *searchBox;
    IBOutlet UIButton *locationDisplay;
    IBOutlet UIButton *employerDisplay;
    IBOutlet UIButton *typeDisplay;
    IBOutlet UIButton *salaryDisplay;
    IBOutlet UIButton *goButton;
    
    NSInteger currentAlterationType;
    NSArray *locationList;
    NSArray *employerList;
    NSArray *typeList;
    NSArray *salaryList;
    NSArray *salaryMappingList;
    
    NSUInteger locationSelection;
    NSUInteger employerSelection;
    NSUInteger typeSelection;
    NSUInteger salarySelection;
    
    NSUInteger titleStartHeight;
}

- (IBAction)fieldChangeRequest:(id)sender;
- (IBAction)performSearch:(id)sender;

@end
