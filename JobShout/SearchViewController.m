//
//  FirstViewController.m
//  JobShout
//
//  Created by Liam Flynn on 23/06/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "SearchViewController.h"
#import "JobListViewController.h"
#import "SearchLocationStrings.h"

@interface SearchViewController()
@property (nonatomic, strong) SearchPickerViewController *multipurposePicker;
@property (nonatomic, strong) NSArray *locationList;
@property (nonatomic, strong) NSArray *employerList;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, strong) NSArray *salaryList;
@property (nonatomic, strong) NSArray *salaryMappingList;
@property (nonatomic, strong) NSArray *dayRateList;
@property (nonatomic, strong) NSArray *dayRateMappingList;
@property (nonatomic, strong) NSArray *hourRateList;
@property (nonatomic, strong) NSArray *hourRateMappingList;
@property (nonatomic, strong) UITextField *searchBox;
@property (nonatomic, strong) UIButton *locationDisplay;
@property (nonatomic, strong) UIButton *employerDisplay;
@property (nonatomic, strong) UIButton *typeDisplay;
@property (nonatomic, strong) UIButton *salaryDisplay;
@property (nonatomic, strong) UIButton *goButton;
@end

@implementation SearchViewController

@synthesize multipurposePicker; 
@synthesize locationList, employerList, typeList, salaryList, salaryMappingList, dayRateList, dayRateMappingList, hourRateList, hourRateMappingList;
@synthesize searchBox, locationDisplay, employerDisplay, typeDisplay, salaryDisplay, goButton;

- (id)init{
	self = [super init];
	
	if(self){        
        locationSelection = 0;
        employerSelection = 0;
        typeSelection = 0;
        salarySelection = 0;
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"Search";
    
    searchBox.delegate = self;
    
    //remove the navigation bar from view
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[self navigationController] setToolbarHidden:YES animated:NO];
    
    currentAlterationType = -1;
    
    NSArray *loc = [[NSArray alloc] initWithObjects:@"All", @"Central London", @"North London", @"South London",  @"East London", @"West London", @"Home Counties", @"South East", @"South West", @"North East", @"North West", @"East Midlands", @"West Midlands", @"Scotland", @"Wales", @"Northern Ireland", @"Overseas", nil];
    self.locationList = loc;
    
    NSArray *emp = [[NSArray alloc] initWithObjects:@"All", @"Branding", @"Creative", @"Design", @"Digital", @"Ecommerce", @"eGov", @"Engineering", @"Finance", @"Health", @"IT & Internet", @"Media", @"Mobile", @"Networks", @"Print & Publishing", @"Professional", @"Public Sector", @"Sales & Marketing", @"Technology", @"Other", nil];    
    
    self.employerList = emp;
    
    NSArray *type = [[NSArray alloc] initWithObjects:@"All", @"Permanent", @"Contract", @"Freelance", @"Part Time", nil];
    self.typeList = type;
    
    NSArray *sal = [[NSArray alloc] initWithObjects: @"All", @"£15k - £20k", @"£20k - £30k", @"£30k - £40k", @"£40k - £50k", @"£50k+", nil];
    self.salaryList = sal;
    
    NSArray *salMap = [[NSArray alloc] initWithObjects: @" ", @"15_20", @"20_30", @"30_40", @"40_50", @"50_above", nil];
    self.salaryMappingList = salMap;
    
    NSArray *day = [[NSArray alloc] initWithObjects: @"All", @"£100 - £150", @"£150 - £200", @"£200 - £250", @"£250 - £300", @"£300 - £350", @"£350 - £400", @"£400+", nil];
    self.dayRateList = day;
    
    NSArray *dayMap = [[NSArray alloc] initWithObjects: @" ", @"100_150", @"150_200", @"200_250", @"250_300", @"300_350", @"350_400", @"400_above", nil];
    self.dayRateMappingList = dayMap;
    
    NSArray *hour = [[NSArray alloc] initWithObjects: @"All", @"£10 - £20", @"£20 - £30", @"£30 - £50", @"£50 - £70", @"£70 - £100", @"£100+", nil];
    self.hourRateList = hour;

    NSArray *hourMap = [[NSArray alloc] initWithObjects: @" ", @"10_20", @"20_30", @"30_50", @"50_70", @"70_100", @"100_above", nil];
    self.hourRateMappingList = hourMap;
    
    multipurposePicker = [[SearchPickerViewController alloc]init];
    multipurposePicker.delegate = self;
    self.searchBox.delegate = self;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.multipurposePicker = nil;
    
    self.locationList = nil;
    self.employerList = nil;
    self.typeList = nil;
    self.salaryList = nil;
    self.salaryMappingList = nil;
    self.dayRateList = nil;
    self.dayRateMappingList = nil;
    self.hourRateList = nil;
    self.hourRateMappingList = nil;
    
    self.searchBox = nil; 
    self.locationDisplay = nil; 
    self.employerDisplay = nil; 
    self.typeDisplay = nil;
    self.salaryDisplay = nil;
    self.goButton = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [[self navigationController] setToolbarHidden:YES animated:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchBox resignFirstResponder];
    return YES;
}

- (IBAction)fieldChangeRequest:(id)sender{
    
    if(sender == locationDisplay){
        currentAlterationType = 0;
        multipurposePicker.contents = self.locationList;
        multipurposePicker.defaultPosition = locationSelection;
        multipurposePicker.contentsTitle = @"Choose a Location";
    }
    else if(sender == employerDisplay){
        currentAlterationType = 1;
        multipurposePicker.contents = self.employerList;
        multipurposePicker.defaultPosition = employerSelection;
        multipurposePicker.contentsTitle = @"Select an Industry";
    }
    else if(sender == typeDisplay){
        currentAlterationType = 2;
        multipurposePicker.contents = self.typeList;
        multipurposePicker.defaultPosition = typeSelection;
        multipurposePicker.contentsTitle = @"Specify a Job Type";
    }
    else if(sender == salaryDisplay){
        currentAlterationType = 3;
        
        if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Contract"]){
            multipurposePicker.contentsTitle = @"Stipulate a Day Rate";
            multipurposePicker.contents = self.dayRateList; 
        }
        else if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Freelance"]
                         || [[typeList objectAtIndex:typeSelection] isEqualToString:@"Part Time"]){
            multipurposePicker.contentsTitle = @"Designate an Hourly Rate";
            multipurposePicker.contents = self.hourRateList;   
        }
        else{
            multipurposePicker.contentsTitle = @"Demand a Salary";
            multipurposePicker.contents = self.salaryList;
        }
        
        multipurposePicker.defaultPosition = salarySelection;
    }
    
    [self presentModalViewController:multipurposePicker animated:YES];
}

- (void)searchPicker:(SearchPickerViewController*)sbjectAlert didChangeSelection:(NSInteger)newSelection{
    
    //mlabel.text = [arrayNo objectAtIndex:newSelection];
    if(currentAlterationType == 0){
        [locationDisplay setTitle:[locationList objectAtIndex:newSelection] forState: UIControlStateNormal]; 
        locationSelection = newSelection;
    }
    else if(currentAlterationType == 1){
        [employerDisplay setTitle:[employerList objectAtIndex:newSelection] forState: UIControlStateNormal]; 
        employerSelection = newSelection;
    }
    else if(currentAlterationType == 2){
        [typeDisplay setTitle:[typeList objectAtIndex:newSelection] forState: UIControlStateNormal];
        typeSelection = newSelection;
        
        //type has changed so will need to reset the salary and it's list may change.
        [salaryDisplay setTitle:[salaryList objectAtIndex:0] forState: UIControlStateNormal];
        salarySelection = 0;
    }
    else if(currentAlterationType == 3){
        
        if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Contract"]){
            [salaryDisplay setTitle:[dayRateList objectAtIndex:newSelection] forState: UIControlStateNormal];
            salarySelection = newSelection;
        }
        else if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Freelance"]
                || [[typeList objectAtIndex:typeSelection] isEqualToString:@"Part Time"]){
            [salaryDisplay setTitle:[hourRateList objectAtIndex:newSelection] forState: UIControlStateNormal];
            salarySelection = newSelection; 
        }
        else{
            [salaryDisplay setTitle:[salaryList objectAtIndex:newSelection] forState: UIControlStateNormal];
            salarySelection = newSelection;
        }
    }
}

- (void)searchPickerFinished:(SearchPickerViewController*)sbjectAlert{
    [self dismissModalViewControllerAnimated:YES];
    currentAlterationType = -1;
}

- (IBAction)performSearch:(id)sender{
    //build string from current search display settings.
    NSMutableString* searchString = [[NSMutableString alloc]initWithFormat:@"%@?limit=%@", kJobServerLocation, kResultsPerSingleRefresh];
    
    if(searchBox.text != nil && ![searchBox.text isEqualToString:@""] && ![searchBox.text isEqualToString:@" "]){
        NSString *stringWithoutAmpersand = [searchBox.text stringByReplacingOccurrencesOfString:@"& " withString:@""];
        [searchString appendFormat:@"&q=%@", stringWithoutAmpersand];
    }
    
    if(![locationDisplay.titleLabel.text isEqualToString:@"All"]){
        [searchString appendFormat:@"&l=%@", locationDisplay.titleLabel.text];
    }
    if(![employerDisplay.titleLabel.text isEqualToString:@"All"]){
        [searchString appendFormat:@"&e=%@", employerDisplay.titleLabel.text];
    }
    if(![typeDisplay.titleLabel.text isEqualToString:@"All"]){
        [searchString appendFormat:@"&t=%@", typeDisplay.titleLabel.text];
    }
    if(![salaryDisplay.titleLabel.text isEqualToString:@"All"]){
        
        if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Contract"]){
            NSString *salaryCode = [dayRateMappingList objectAtIndex:salarySelection];
            [searchString appendFormat:@"&s=%@", salaryCode];
        }
        else if([[typeList objectAtIndex:typeSelection] isEqualToString:@"Freelance"]
                || [[typeList objectAtIndex:typeSelection] isEqualToString:@"Part Time"]){
            NSString *salaryCode = [hourRateMappingList objectAtIndex:salarySelection];
            [searchString appendFormat:@"&s=%@", salaryCode];
        }
        else{
            NSString *salaryCode = [salaryMappingList objectAtIndex:salarySelection];
            [searchString appendFormat:@"&s=%@", salaryCode];
        }
    }
    
   // NSString* escapedUrlString = [searchString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    //NSLog(@"%@",escapedUrlString);  
    
    JobListViewController *detailViewController = [[JobListViewController alloc] initWithNibName:@"JobListView" bundle:nil];
    
    DebugLog(@"%@",searchString);
    detailViewController.title = @"Results";
    detailViewController.targetURL = searchString;
    detailViewController.termianlDrillList = YES;
    detailViewController.loadPhrase = @"Searching…";
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Only characters in the NSCharacterSet you choose will insertable.
    NSCharacterSet *invalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@" "];
    return [string isEqualToString:filtered];
}

@end
