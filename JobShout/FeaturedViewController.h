//
//  FeaturedViewController.h
//  JobShout
//
//  Created by Liam Flynn on 10/07/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedViewController : UITableViewController {
    NSArray* featuredCategories;
}

@property(nonatomic,strong) NSArray* featuredCategories;

@end
