//
//  JobRecord.m
//  JobShout
//
//  Created by Liam Flynn on 26/06/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import "JobRecord.h"

@implementation JobRecord

@synthesize appName;
@synthesize appIcon;
@synthesize imageURLString;
@synthesize artist;
@synthesize appURLString;

- (void)dealloc
{
    [appName release];
    [appIcon release];
    [imageURLString release];
	[artist release];
    [appURLString release];
    
    [super dealloc];
}

@end
