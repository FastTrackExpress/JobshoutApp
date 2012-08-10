//
//  PickerViewAlert.m
//  JobShout
//
//  Created by Liam Flynn on 10/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "PickerViewAlert.h"


@interface PickerViewAlert()
-(void)dismissActionSheet:(id)sender;
@end

@implementation PickerViewAlert

@synthesize delegate, contents, defaultPosition;

-(id)init{
	self = [super init];
	
	if(self){
        
	}
	return self;
}


- (void)showPickerinToolbar:(UIToolbar*)parentBar withDefault:(NSUInteger)position{
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:position inComponent:0 animated:NO];
    
    [actionSheet addSubview:pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Select"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    
    [actionSheet addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    
    [actionSheet showFromToolbar:parentBar];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
}

- (void)dismissActionSheet:(id)sender{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [delegate pickerViewAlertFinished:self];
    //[self dismissActionSheet:sender];
    //[(UIActionSheet*)sender dismissWithClickedButtonIndex:<#(NSInteger)#> animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //mlabel.text=    [arrayNo objectAtIndex:row];
    [delegate pickerViewAlert:self didChangeSelection:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [contents count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [contents objectAtIndex:row];
}

@end
