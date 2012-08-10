//
//  JobRecord.h
//  JobShout
//
//  Created by Liam Flynn on 26/06/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JobRecord : NSObject {
    NSString *appName;
    UIImage *appIcon;
    NSString *artist;
    NSString *imageURLString;
    NSString *appURLString;
}

@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) UIImage *appIcon;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *appURLString;

@end
