//
//  FeaturedViewController.m
//  JobShout
//
//  Created by Liam Flynn on 10/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "FeaturedViewController.h"
#import "JobListViewController.h"
#import "SearchLocationStrings.h"

@implementation FeaturedViewController

@synthesize featuredCategories;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
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
    
    self.title = @"Featured";
    
    NSArray *categoryList = [[NSArray alloc] initWithObjects: @"Latest", @"Category", @"Industry", @"Location", nil];
    self.featuredCategories = categoryList;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 165)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JobshoutGreyLogo"]];
    CGRect frm = imageView.frame;
    frm.origin.x = 15;
    frm.origin.y = 42;
    imageView.frame = frm;
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 30)];
    labelView.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:15.0];
    labelView.textColor = [UIColor darkGrayColor];
    labelView.backgroundColor = [UIColor clearColor];
    labelView.textAlignment = UITextAlignmentCenter;
    labelView.text = @"Featured Jobs by...";
    [headerView addSubview:labelView];
    
    [headerView addSubview:imageView];
    self.tableView.tableHeaderView = headerView;
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.featuredCategories = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [[self navigationController] setToolbarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [featuredCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    cell.textLabel.text = [featuredCategories objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Navigation logic may go here. Create and push another view controller.
    JobListViewController *detailViewController = [[JobListViewController alloc] initWithNibName:@"JobListView" bundle:nil];
    
    if([(NSString*)[featuredCategories objectAtIndex:indexPath.row] isEqualToString:@"Category"]){
        detailViewController.termianlDrillList = NO;
        detailViewController.usingSearchBar = YES;
        detailViewController.title = @"Jobs by Category";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Categories" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [detailViewController.navigationItem setBackBarButtonItem: backButton];
        
        detailViewController.targetURL = kJobServerCategoryListLocation;
    }
    else if([(NSString*)[featuredCategories objectAtIndex:indexPath.row] isEqualToString:@"Industry"]){
        detailViewController.termianlDrillList = NO;
        detailViewController.usingSearchBar = YES;
        detailViewController.title = @"Jobs by Industry";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Types" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [detailViewController.navigationItem setBackBarButtonItem: backButton];
        
        detailViewController.targetURL = kJobServerEmployerListLocation;
    }
    else if([(NSString*)[featuredCategories objectAtIndex:indexPath.row] isEqualToString:@"Latest"]){
        detailViewController.termianlDrillList = YES;
        detailViewController.usingSearchBar = NO;
        detailViewController.title = @"Latest Jobs";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Latest" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [detailViewController.navigationItem setBackBarButtonItem: backButton];
        
        detailViewController.targetURL = kJobServerLatestListLocation;
    }
    else if([(NSString*)[featuredCategories objectAtIndex:indexPath.row] isEqualToString:@"Location"]){
        detailViewController.termianlDrillList = NO;
        detailViewController.usingSearchBar = YES;
        detailViewController.title = @"Jobs by Location";
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                       initWithTitle: @"Locations" 
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [detailViewController.navigationItem setBackBarButtonItem: backButton];
        
        detailViewController.targetURL = kJobServerRegionListLocation;
    }
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
