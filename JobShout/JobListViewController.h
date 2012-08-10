//
//  JobListViewController.h
//  JobShout
//
//  Created by Liam Flynn on 02/07/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobServerRequst.h"
#import "JobDetailViewController.h"
#import "RssItem.h"

@interface JobListViewController : UITableViewController<JobServerRequstDelegate, UISearchBarDelegate> {
    
    NSString *targetURL;
    NSString *searchPhrase;
    NSString *loadPhrase;
    
    BOOL termianlDrillList;
    BOOL usingSearchBar;
    
    JobServerRequst *jobListLoader;
    
    BOOL jobListReturnFailed;
    BOOL moreButtonSelected;
    BOOL searchPerformed;
    
    NSInteger currentOffset;
    
    UISearchBar *jobSearchBar;
    UIView *disableViewOverlay;
    
    @protected NSMutableArray* jobTitles;
    
    @protected NSMutableArray* jobTitlesPreSearch;
}

@property (nonatomic, strong) NSString *targetURL;
@property (nonatomic, strong) NSString *searchPhrase;
@property (nonatomic, strong) NSString *loadPhrase;

@property (nonatomic, assign, getter=isTermianlDrillList) BOOL termianlDrillList;
@property (nonatomic, assign, getter=isUsingSearchBar) BOOL usingSearchBar;

@property (nonatomic, strong) JobServerRequst *jobListLoader;
@property (nonatomic, strong) UIView *disableViewOverlay;


@end
