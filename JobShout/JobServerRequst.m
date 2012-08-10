//
//  MultipleAttemptServerRequst.m
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import "JobServerRequst.h"

@interface JobServerRequst()
@property(nonatomic,strong) NSMutableArray* resultArray;
- (void)handleRepeatSend:(ServerState)resendReason;
- (void)performResend;
- (void)beginXMLParse;
@end

@implementation JobServerRequst

@synthesize delegate, parser, maxSendRepeats, requestString, resultArray, connectionData, totalAvailableResults;

- (id)init{
	self = [super init];
	
	if(self){
        maxSendRepeats = 3;
        currentSendRepeat = 0;
        
        connection = [[ConnectionHandler alloc]init];
        connection.delegate = self;
        
        connectionData = [[NSMutableData alloc]init];
	}
	return self;
}

- (void)dealloc{
    [connection clearOutstandingRequests];
    connection.delegate = nil;
}

- (void)connectAndAppendToArray:(NSMutableArray*)result usingRequest:(NSString*)request{
    self.resultArray = result;
    self.requestString = request;
    
    [connection fillConnectionData:connectionData usingRequest:requestString];
    //call the complete here for now as temp action
}

- (void)connectionHandlerResult:(ServerState)resultState withData:(NSMutableData*)finalData{
    
    if(resultState == SERVER_OK){
        [self beginXMLParse]; 
    }
    else{
        //resend or timeout.
        [self handleRepeatSend:resultState];
    }
}

- (void)beginXMLParse{
    
    // create an ParseOperation (NSOperation subclass) to parse the RSS feed data so that the UI is not blocked
    // "ownership of appListData has been transferred to the parse operation and should no longer be
    // referenced in this thread.
    
    ParseOperation *xmlParser = [[ParseOperation alloc] initWithData:connectionData delegate:self];
    self.parser = xmlParser;
    [parser parseAsyncronous];
    
    NSMutableData *newData = [[NSMutableData alloc]init];
    self.connectionData = newData;
}

- (void)didFinishParsing:(ParseOperation *)resultParser{
    
    totalAvailableResults = resultParser.totalAvailableItems;
    
    [self.resultArray addObjectsFromArray:parser.workingArray];
    [delegate requestResult:SERVER_OK withArray:resultArray];
}

- (void)parseErrorOccurred:(NSError *)error{
    [self handleRepeatSend:SERVER_RESPONSE_ERROR];
}

- (void)handleRepeatSend:(ServerState)resendReason{
	//now calculate if and when a repeat send should be performed or return the current error to delegate.
	NSUInteger incrementValue = 1;
	
	//add additional repeat if timeout as will have taken much longer, don't want too many.
	if(resendReason == SERVER_TIMEOUT){
		incrementValue = 2;
	}
	
	currentSendRepeat += incrementValue;
	
	if(currentSendRepeat < maxSendRepeats){
		NSTimeInterval resendPauseInterval = 0.2;
		
		if(resendReason == SERVER_TOO_BUSY){
			resendPauseInterval = 2.0;
		}
		
		resendPauseTimer = [NSTimer scheduledTimerWithTimeInterval: resendPauseInterval target: self 
                                                          selector: @selector(performResend) userInfo: nil repeats: NO];
	}
	else{ 
        //has repeated maximum number of tries, now time to fail gracefully.
		currentSendRepeat = 0;
        
        if(resendReason == SERVER_CONNECT_ERROR){
            //there may be a connection error, let the user know.
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Please check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        
        //inform delegate that the request has failed.
		[delegate requestResult:resendReason withArray:resultArray];
	}
}

- (void)performResend{
    //nil off timer so cleared up.
    if(resendPauseTimer != nil){
        [resendPauseTimer invalidate];
        resendPauseTimer = nil;
    }
    
    [connection fillConnectionData:connectionData usingRequest:requestString];
}

@end
