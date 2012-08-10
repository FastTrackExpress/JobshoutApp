//
//  ConnectionHandler.h
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 TenthMatrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerState.h"

@protocol ConnectionHandlerDelegate;

@interface ConnectionHandler : NSObject {
    
    id<ConnectionHandlerDelegate> __unsafe_unretained delegate;
    
    ServerState currentErrorState;
    NSURLConnection* connectionResponse;
    NSTimer* checkResponseReceivedTimer;
    
    NSMutableData* responseDataPtr;
}

@property(nonatomic, unsafe_unretained) id<ConnectionHandlerDelegate> delegate;
@property(nonatomic, unsafe_unretained) ServerState currentErrorState;
@property(nonatomic, strong)  NSMutableData* responseDataPtr; 

- (void)fillConnectionData:(NSMutableData*)returnData usingRequest:(NSString*)requestString;
- (void) clearOutstandingRequests;

@end

@protocol ConnectionHandlerDelegate
-(void) connectionHandlerResult:(ServerState)resultState withData:(NSMutableData*)finalData;
@end

