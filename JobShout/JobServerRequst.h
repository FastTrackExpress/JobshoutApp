//
//  MultipleAttemptServerRequst.h
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionHandler.h"
#import "ParseOperation.h"
#import "ServerState.h"

@protocol JobServerRequstDelegate;

@interface JobServerRequst : NSObject<ConnectionHandlerDelegate, ParseOperationDelegate>{
    
    id<JobServerRequstDelegate> __unsafe_unretained delegate;
    
    ConnectionHandler* connection;
    
    NSMutableData* connectionData;
    
    //timer to handle repeat of send and slight delay of repeat where required
	NSTimer* resendPauseTimer;
    NSTimeInterval sendRepeatInterval;
	NSUInteger currentSendRepeat;
	NSUInteger maxSendRepeats;
    
    NSString* requestString;
    //loaded objects
    NSMutableArray* resultArray;
    NSInteger totalAvailableResults;
    
    ParseOperation *parser;
}

@property(nonatomic, unsafe_unretained) id<JobServerRequstDelegate> delegate;
@property(nonatomic, strong) ParseOperation *parser;
@property(nonatomic, strong) NSString* requestString;
@property (nonatomic, strong) NSMutableData* connectionData;
@property(nonatomic, assign) NSUInteger maxSendRepeats;
@property(nonatomic, assign) NSInteger totalAvailableResults;

- (void)connectAndAppendToArray:(NSMutableArray*)result usingRequest:(NSString*)request;

@end

@protocol JobServerRequstDelegate
-(void) requestResult:(NSInteger)resultState withArray:(NSArray*)resultData;
@end
