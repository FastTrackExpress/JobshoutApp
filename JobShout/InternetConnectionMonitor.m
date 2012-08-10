//
//  CBBotInteraction.m
//  MainCleverbotProject
//
//  Created by Liam Flynn on 06/08/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "InternetConnectionMonitor.h"

@implementation InternetConnectionMonitor

@synthesize hostActive, internetActive;

- (id)init{
    self = [super init];
    if (self) {
        //set up reachability observers and monitor reachability.
        // check for internet connection
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        internetReachable = [Reachability reachabilityForInternetConnection];
        [internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        //hostReachable = [[Reachability reachabilityWithHostName: @"http://www.jobshout.com/"] retain];
        //[hostReachable startNotifier];
        
        //initial check of internet connection. 
        [self networkStatusRecheck];
    }
    
    return self;
}

- (void)dealloc{
    
    //remove any notification that is related to this observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -
#pragma mark reachability status change.
- (void) checkNetworkStatus:(NSNotification *)notice{
    [self networkStatusRecheck];
}

-(void) networkStatusRecheck{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus){
        case NotReachable:{
            DebugLog(@"The internet is down.");
            self.internetActive = NO;
            [self noConnectionAlert:internetActive];
            break;
            
        }
        case ReachableViaWiFi:{
            DebugLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:{
            DebugLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
            
        }
    }
    
    /*NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus){
        case NotReachable:{
            DebugLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            [self noConnectionAlert:internetActive];
            
            break;
            
        }
        case ReachableViaWiFi:{
            DebugLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
            
        }
        case ReachableViaWWAN:{
            DebugLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            
            break;
            
        }
    }*/
}

- (void) noConnectionAlert:(BOOL)hasInternet{
    
    NSString *errorMessage;
    
    if(hasInternet){
        errorMessage = [[NSString alloc] initWithFormat:@"Jobshout server not found. \n You may have a firewall active."];
    }
    else{
        errorMessage = [[NSString alloc] initWithFormat:@"This app requires internet access. \n Please check your connection."]; 
    }
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle: @"Connection Error"
                               message: errorMessage
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
    
    
}

@end
