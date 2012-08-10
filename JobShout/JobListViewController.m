//
//  JobListViewController.m
//  JobShout
//
//  Created by Liam Flynn on 02/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "JobListViewController.h"
#import "SearchLocationStrings.h"
#import "RssItem.h"

@interface JobListViewController()
@property (nonatomic, retain) NSMutableArray* jobTitles;
@property (nonatomic, retain) NSMutableArray* jobTitlesPreSearch;
- (void)performSearchWithArray:(NSArray*)subjectArray andString:(NSString*)searchString andPlaceInDestiantion:(NSMutableArray *)desitnation;
- (void)requestMoreResults;
@end

@implementation JobListViewController

@synthesize termianlDrillList, usingSearchBar;
@synthesize targetURL, searchPhrase, jobListLoader, loadPhrase;
@synthesize jobTitles, jobTitlesPreSearch;
@synthesize disableViewOverlay;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        jobListReturnFailed = NO;
        termianlDrillList = NO;
        moreButtonSelected = NO;
        usingSearchBar = NO;
        currentOffset = 0;
        searchPerformed = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    jobListReturnFailed = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    jobListLoader = [[JobServerRequst alloc]init];
    jobListLoader.delegate = self;
    
    NSMutableArray *currentJobTitles = [[NSMutableArray alloc]init]; 
    self.jobTitles = currentJobTitles;// [NSArray arrayWithObjects:@"Loading...", nil];
    
    NSMutableArray *currentJobTitlesPreSearch = [[NSMutableArray alloc]init]; 
    self.jobTitlesPreSearch = currentJobTitlesPreSearch;// [NSArray arrayWithObjects:@"Loading...", nil];
    
    NSString* requestString;
    
    //if there is a target url then us it, otherwise use seach term.
    if(self.targetURL != nil){
        requestString = self.targetURL;
    }
    else{
        requestString = [[NSString alloc] initWithFormat:@"%@?limit=%@&%@", kJobServerLocation, kResultsPerSingleRefresh, searchPhrase];
    }
       
    //encode the string to a safe format for a URL.
    NSString* escapedUrlString = [requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [jobListLoader connectAndAppendToArray:jobTitlesPreSearch usingRequest:escapedUrlString];
    
    if(usingSearchBar){
        jobSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];  
        jobSearchBar.delegate = self;
        jobSearchBar.barStyle = UIBarStyleBlackOpaque;
        jobSearchBar.tintColor = [UIColor darkGrayColor];
        [jobSearchBar sizeToFit];  
        
        self.tableView.tableHeaderView = jobSearchBar;  
        
        UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,44.0f,480.0f,416.0f)];
        self.disableViewOverlay = overlayView; 
        
        self.disableViewOverlay.backgroundColor = [UIColor blackColor]; 
        self.disableViewOverlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
        self.disableViewOverlay.alpha = 0; 
        [self.view addSubview:disableViewOverlay];
    }
}

- (void)requestResult:(int)resultState withArray:(NSArray*)resultData{
    
    if(resultState != 0 || [resultData count] < 1){
        jobListReturnFailed = YES;
    }
    
    [jobTitles removeAllObjects];
    [jobTitles addObjectsFromArray:jobTitlesPreSearch];
    
    [self.tableView reloadData];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    //clear the lists but do not clear the search term as may need it if move pop back onto view.
    self.jobListLoader = nil;
    self.jobTitles = nil;
    self.jobTitlesPreSearch = nil;
    self.disableViewOverlay = nil;
    
    jobListReturnFailed = NO;
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
    NSInteger categoryCount = [jobTitles count];
    
    if(categoryCount == 0){
        return 1;
    }
    
    //if not using the search bar create an additional cell for the search bar. 
    if(categoryCount < jobListLoader.totalAvailableResults && !usingSearchBar){
        
        //there are more items than being displayed, so add a single position for more button. 
        categoryCount++;
    }
    
    return categoryCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([jobTitles count] > 0){
        //has resutls.
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        
        if(indexPath.row < [jobTitles count]){
            RssItem* job = [self.jobTitles objectAtIndex:indexPath.row];
            cell.textLabel.text = job.displayTitle;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        }
        else{
            if(moreButtonSelected){
                cell.textLabel.text = @"Refreshing…";
            }
            else{
                cell.textLabel.text = @"More…";
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone; 
        }
        
    }
    else if(jobListReturnFailed){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
        cell.textLabel.text = @"No jobs available.";
        cell.accessoryType = UITableViewCellAccessoryNone; 
    }
    else{
        cell.textLabel.textColor = [UIColor grayColor];
        
        if(searchPerformed){
            cell.textLabel.text = @"No matching results.";
        }
        else if(loadPhrase != nil){
            cell.textLabel.text = loadPhrase;
        }
        else{
            cell.textLabel.text = @"Refreshing…";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone; 
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([jobTitles count] > 0){
        // Navigation logic may go here. Create and push another view controller.
        
        if(indexPath.row < [jobTitles count]){
            
            //an item has been selected
            if([self isTermianlDrillList]){
                // Pass the selected object to the new view controller.
                JobDetailViewController *detailViewController = [[JobDetailViewController alloc] initWithNibName:@"JobDetailView" bundle:nil];
                detailViewController.title = @"Description";
                detailViewController.job = [self.jobTitles objectAtIndex:indexPath.row];
                
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
            else{
                //drill down into another list.
                JobListViewController *detailViewController = [[JobListViewController alloc] initWithNibName:@"JobListView" bundle:nil];
                
                RssItem* nextJobList = [self.jobTitles objectAtIndex:indexPath.row];
                
                detailViewController.title = nextJobList.displayTitle;
                detailViewController.termianlDrillList = YES;
                detailViewController.targetURL = nextJobList.link;
                
                [self.navigationController pushViewController:detailViewController animated:YES];
            }
        }
        else{
            //the more button has been selected (do not allow repeat selection).
            if(!moreButtonSelected){
                [self requestMoreResults];
            }
        }
    }
}

- (void)requestMoreResults{
    currentOffset += [kResultsPerSingleRefresh intValue];
    
    NSMutableString* requestString;
    
    //if there is a target url then us it, otherwise use seach term.
    if(self.targetURL != nil){
        requestString = [self.targetURL mutableCopy];
    }
    else{
        requestString = [[NSMutableString alloc] initWithFormat:@"%@?limit=%@&%@", kJobServerLocation, kResultsPerSingleRefresh, searchPhrase];
    }
    
    [requestString appendFormat:@"&start=%@", [NSNumber numberWithInt:currentOffset]];
    
    //encode the string to a safe format for a URL.
    NSString* escapedUrlString = [requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    [jobListLoader connectAndAppendToArray:jobTitlesPreSearch usingRequest:escapedUrlString];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    
    [UIView beginAnimations:@"FadeIn" context:nil]; 
    [UIView setAnimationDuration:0.3]; 
    self.disableViewOverlay.alpha = 0.6f; 
    [UIView commitAnimations]; 
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [UIView beginAnimations:@"FadeOut" context:nil]; 
    [UIView setAnimationDuration:0.3]; 
    self.disableViewOverlay.alpha = 0.0f; 
    [UIView commitAnimations]; 
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [self.jobTitles removeAllObjects];
    [self performSearchWithArray:jobTitlesPreSearch andString:searchBar.text andPlaceInDestiantion:jobTitles];
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [UIView beginAnimations:@"FadeOut" context:nil]; 
    [UIView setAnimationDuration:0.3]; 
    self.disableViewOverlay.alpha = 0.0f; 
    [UIView commitAnimations];
    
    [self.tableView reloadData];
}

- (void)performSearchWithArray:(NSArray*)subjectArray andString:(NSString*)searchString andPlaceInDestiantion:(NSMutableArray *)desitnation{
    
    for(NSInteger i = 0; i < [subjectArray count]; i++){
        
        searchPerformed = YES;
        RssItem *currentItem = [subjectArray objectAtIndex:i];
        
        NSRange range = [[currentItem.title lowercaseString] rangeOfString:[searchString lowercaseString]];
        
        //if search string is not valid them add all items so that no filtering is done.
        if(range.location != NSNotFound || searchString == nil || [searchString isEqualToString:@""] || [searchString isEqualToString:@" "]){
            [desitnation addObject:currentItem]; 
        }
    }
    
    //if invalid then search is all and so not actually a search.
    if(searchString ==nil || [searchString isEqualToString:@""] || [searchString isEqualToString:@" "]){
        searchPerformed = NO;
    }
}

@end
