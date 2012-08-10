//
//  LevelXMLParser.h
//  IcognoCleverbotProject
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerState.h"
#import "EntityStringHelper.h"

@protocol RSSJobListResponseParserDelegate
-(void) jobParseResult:(ServerState)resultState withDictionary:(NSArray*)resultsArray;
@end

@interface RSSJobListResponseParser : NSObject<NSXMLParserDelegate> {
    
    id<RSSJobListResponseParserDelegate> delegate;
    ServerState currentErrorState;
    
    NSString* xmlAsString;
    
    NSMutableDictionary* currentStateStore;
	NSMutableString* currentProperty;
	//NSXMLParser* addressParser;
	Boolean newProperty;
    
    NSTimer* checkDocumentEndedTimer;
    
    NSMutableString* currentKeyObject;
    
    Boolean retainDictionaryDataBetweenRequests;
}

@property(nonatomic, retain) NSString* xmlAsString;
@property(assign) id<XMLResponseParserDelegate> delegate;
@property(assign) ServerState currentErrorState;


- (void)deconstructXMLResponse:(NSData *)data intoDicrionary:(NSMutableDictionary*)resultsArray;

@end
