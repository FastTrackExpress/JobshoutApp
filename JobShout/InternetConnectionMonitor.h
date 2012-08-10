//
//  CBBotInteraction.h
//  MainCleverbotProject
//
//  Created by Liam Flynn on 06/08/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface InternetConnectionMonitor : NSObject{
    
    //variables for checking reacability of Cleverbot servers on startup.
    Reachability* internetReachable;
    //Reachability* hostReachable;
    //NetworkStatus hostActive;
    NetworkStatus internetActive;
}

- (void) networkStatusRecheck;
- (void) noConnectionAlert:(BOOL)hasInternet;

@property (nonatomic, assign) NetworkStatus hostActive;
@property (nonatomic, assign) NetworkStatus internetActive;

@end
