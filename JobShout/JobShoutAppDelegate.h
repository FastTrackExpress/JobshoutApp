//
//  JobShoutAppDelegate.h
//  JobShout
//
//  Created by Liam Flynn on 23/06/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InternetConnectionMonitor.h"

@interface JobShoutAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    InternetConnectionMonitor *connectionMonitor;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) InternetConnectionMonitor *connectionMonitor;

@end
