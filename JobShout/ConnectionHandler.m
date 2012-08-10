//
//  ConnectionHandler.m
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import "ConnectionHandler.h"

//need to parse out additional xml send parameters (new connection)
//need to have overall response timer as well as just connection.

@implementation ConnectionHandler

@synthesize delegate, currentErrorState, responseDataPtr;

- (id)init{
	self = [super init];
	
	if(self){
        
	}
	return self;
}

- (void)dealloc{
    [self clearOutstandingRequests];
}

//server request and response functions
- (void)fillConnectionData:(NSMutableData*)returnData usingRequest:(NSString*)requestString{
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
	//NSURL *webServiceURL = [NSURL URLWithString:@"http://www.cleverbot.com/webservicexml"];
    self.responseDataPtr = returnData;
	
	//reset error state so that ill not cause false negative.
	currentErrorState = SERVER_OK;

	NSURL *webServiceURL = [NSURL URLWithString:requestString];
	
	//this line is added to ignore certificate errors from https. Additionlly, the privete interface at
	//the top is needed to do this. It is a private method the us officially unsupported by the API. 
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:webServiceURL
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
														  timeoutInterval:58.0];
	
	[urlRequest setHTTPShouldHandleCookies:NO];
	[urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
	
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[requestString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
	
	NSTimeInterval timeInterval = 60.0;
    
	checkResponseReceivedTimer = [NSTimer scheduledTimerWithTimeInterval: timeInterval target: self 
																selector: @selector(responseTimeout:) userInfo: nil repeats: NO];
	
	
    connectionResponse = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	
	if (connectionResponse){
		DebugLog(@"Request submitted:%@", requestString);
	} 
	else{
		DebugLog(@"Failed to submit request");
		currentErrorState = SERVER_CONNECT_ERROR;
		[delegate connectionHandlerResult:SERVER_CONNECT_ERROR withData:nil];
	}
}

- (BOOL)connection:(NSURLConnection *)connection  canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{  
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}   

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{  
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        //if ([trustedHosts containsObject:challenge.protectionSpace.host]){
        [challenge.sender useCredential:[NSURLCredential  credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge]; 
        //}
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


- (void)responseTimeout:(NSTimer*)timer{
	
	currentErrorState = SERVER_TIMEOUT;
	
	//clear up data to prevent error or success functions from being called.
	
	//check timer is invalid
	if(checkResponseReceivedTimer){
		[checkResponseReceivedTimer invalidate];
		checkResponseReceivedTimer = nil;
	}
	
	if(connectionResponse){
		//prevent the timer from calling a timeout and clear any memory.
		[self clearOutstandingRequests];
		
		//call server timeout.
        [delegate connectionHandlerResult:SERVER_TIMEOUT withData:nil];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if(checkResponseReceivedTimer){
		[checkResponseReceivedTimer invalidate];
		checkResponseReceivedTimer = nil;
	}
	
	long length = [response expectedContentLength];
	
	if(length == NSURLResponseUnknownLength){
		//if this is detected should not parse as there is nothing to parse.
		currentErrorState = SERVER_BLANK_RESPONSE;
	}
	
	[responseDataPtr setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if(checkResponseReceivedTimer){
		[checkResponseReceivedTimer invalidate];
		checkResponseReceivedTimer = nil;
	}
    
	[responseDataPtr appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if(checkResponseReceivedTimer){
		[checkResponseReceivedTimer invalidate];
		checkResponseReceivedTimer = nil;
	}
	
	DebugLog(@"Error receiving response: %@", error);
	
	//prevent the timer from calling a timeout and clear any memory.
	[self clearOutstandingRequests];
	[self.delegate connectionHandlerResult:SERVER_CONNECT_ERROR withData:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	if (currentErrorState == SERVER_OK){
        [self.delegate connectionHandlerResult:SERVER_OK withData:responseDataPtr];
	}
	else{
        [self.delegate connectionHandlerResult:SERVER_BLANK_RESPONSE withData:nil];
	}
    
    [self clearOutstandingRequests];
}

- (void)clearOutstandingRequests{
    self.responseDataPtr = nil;
    
    if(checkResponseReceivedTimer){
        [checkResponseReceivedTimer invalidate];
        checkResponseReceivedTimer = nil;
    }
    
	if(connectionResponse){
		[connectionResponse cancel];
		connectionResponse = nil;
	}
}

@end
