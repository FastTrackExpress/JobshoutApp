//
//  LevelXMLParser.m
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import "XMLResponseParser.h"


@interface RSSJobListResponseParser(Private)
-(void) initialSetup;
-(void)replaceHtmlEntities:(NSData *)data;
-(void)setCurrentProperty:(NSString*)propertyKey;

@end

//need to parse out additional xml send parameters (new connection)
//need to have overall response timer as well as just connection.

@implementation RSSJobListResponseParser

@synthesize delegate, currentErrorState, xmlAsString;

-(id)init{
	self = [super init];
	
	if(self){
        [self initialSetup]; 
	}
	return self;
}

-(void) initialSetup{
}

- (void)deconstructXMLResponse:(NSData *)data intoDicrionary:(NSMutableDictionary*)resultsDictionary{	
	//added as an attempt to stop memory leaks.
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
    
    currentStateStore = resultsDictionary;
	
	[self performSelector:@selector(replaceHtmlEntities:) withObject:data afterDelay:0];
}

- (void)replaceHtmlEntities:(NSData *)data{
    
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	self.xmlAsString = dataString;
    [dataString release];
	
	DebugLog(@"XML response: %@", xmlAsString);
	
	NSRange textRange = [xmlAsString rangeOfString:@"<!--too busy-->"];
	
	//if check for too busy tag comes up clean try an xml based one, less reliable but not dependant upon tag.
	if(textRange.location != NSNotFound){
		textRange = [xmlAsString rangeOfString:@" "];
	}
	
	if(textRange.location != NSNotFound){
        [delegate xmlParseResult:SERVER_TOO_BUSY withDictionary:currentStateStore];
	}
	else{
        
		[NSThread detachNewThreadSelector:@selector(removeEntitesFromReceivedString:) toTarget:self withObject:xmlAsString]; 
		
		//NSData* entityFreeUTF8 = [entityFreeTemp dataUsingEncoding:NSUTF8StringEncoding];
		//[self parseData:entityFreeUTF8];
	}
}

-(void)removeEntitesFromReceivedString:(NSString*)receivedString{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
	
	NSString* entityFreeTemp = [EntityStringHelper decodeCharacterEntitiesIn:receivedString];
	NSData* entityFreeUTF8 = [entityFreeTemp dataUsingEncoding:NSUTF8StringEncoding];
	
    [self performSelectorOnMainThread:@selector(parseData:) withObject:entityFreeUTF8 waitUntilDone:NO]; 
	
	[pool release]; 
}

-(void)parseData:(NSData*)parseData{
	
	NSXMLParser* addressParser = [[NSXMLParser alloc] initWithData:parseData];
    [addressParser setDelegate:self];
	//[addressParser setShouldResolveExternalEntities:YES];
	
	//only parse the data returned if there has not been an error detected with it.
	if(currentErrorState == SERVER_OK){
		[addressParser parse];
	}
	
	[addressParser release];
	//[deEntitiedData autorelease];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
   
    
	DebugLog(@"Found element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	DebugLog(@"%@",string);
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //if the element has anything set to null so things inbetween will be ignored.
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	
	DebugLog(@"Error %i, Description: %@, Line: %i, Column: %i", 
             [parseError code], [parseError localizedDescription],
             [parser lineNumber], [parser columnNumber]);
	
    
}

-(void) checkDocumentEnded:(NSTimer*)timer{
	
	//timer is finished. 
	checkDocumentEndedTimer = nil;
	
	//carry out timer instructions.
	if(currentErrorState != SERVER_OK){
		[self parserDidEndDocument:nil];
	}	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	
	if(checkDocumentEndedTimer){
		[checkDocumentEndedTimer invalidate];
		checkDocumentEndedTimer = nil;
	}
    
    NSMutableString* sessionIdObjectObject = [currentStateStore objectForKey:@"sessionid"];
    
    //if there is a session id and it includes the words DENIED then there is a response error.
    if(sessionIdObjectObject != nil){
        NSRange toprange = [sessionIdObjectObject rangeOfString: @"DENIED"];
    
        if(toprange.location != NSNotFound){
            currentErrorState =	SERVER_RESPONSE_ERROR;
        }
    }
    
	//do not add a corrupted message. Error will have already been trigerred.
	if(currentErrorState == SERVER_OK){	
        [delegate xmlParseResult:SERVER_OK withDictionary:currentStateStore];
	}
	else{
		//message was corrupted so re-transmit it.
		[delegate xmlParseResult:SERVER_RESPONSE_ERROR withDictionary:currentStateStore];
	}
    
    self.xmlAsString = nil;
}


-(void)dealloc{
    
    if(checkDocumentEndedTimer){
		[checkDocumentEndedTimer invalidate];
		checkDocumentEndedTimer = nil;
	}
    
    [xmlAsString release];
    
    [super dealloc];
}

@end
