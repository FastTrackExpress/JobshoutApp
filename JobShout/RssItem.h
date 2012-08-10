//
//  RssItem.h
//  JobShout
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 aaa. All rights reserved.
//

@interface RssItem : NSObject{
    NSString *title;
    NSString *description;
    NSString *link;
    NSString *pubDate;
    NSString *referenceCode;
    NSString *contactEmail;
    
    //Not part of RSS definition but is short version of title for table views. 
    NSString *displayTitle;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *pubDate;
@property (nonatomic, strong) NSString *referenceCode;
@property (nonatomic, strong) NSString *contactEmail;

@property (nonatomic, strong) NSString *displayTitle;

@end