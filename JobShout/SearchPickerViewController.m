//
//  SearchPickerViewController.m
//  JobShout
//
//  Created by Liam Flynn on 24/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "SearchPickerViewController.h"

@interface SearchPickerViewController()

@property (nonatomic, unsafe_unretained) IBOutlet UITextField *subTitle;
@property (nonatomic, unsafe_unretained) IBOutlet UIPickerView *picker;
@property (nonatomic, unsafe_unretained) IBOutlet UIButton *acceptButton;

-(IBAction)dismissActionSheet:(id)sender;
@end

@implementation SearchPickerViewController

@synthesize delegate, contents, defaultPosition, subTitle, picker, acceptButton, contentsTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)dismissActionSheet:(id)sender{
    [delegate searchPickerFinished:self];
    //[self dismissActionSheet:sender];
    //[(UIActionSheet*)sender dismissWithClickedButtonIndex:<#(NSInteger)#> animated:YES];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //mlabel.text=    [arrayNo objectAtIndex:row];
    [delegate searchPicker:self didChangeSelection:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    return [contents count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;{
    return [contents objectAtIndex:row];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
    [picker reloadAllComponents];
    [picker selectRow:defaultPosition inComponent:0 animated:NO];
    
    subTitle.text = self.contentsTitle;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.subTitle = nil;
    self.picker = nil;
    self.acceptButton = nil;
    self.contentsTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
