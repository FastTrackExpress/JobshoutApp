

#import "ParseOperation.h"
#import "RssItem.h"

// string contants found in the RSS feed
static NSString *kTotalJobsStr    = @"totalItems";
static NSString *kTotalAvailableJobsStr    = @"totalResults";

static NSString *kEntryStr        = @"item";

static NSString *kTitleStr        = @"title";
static NSString *kDescriptionStr  = @"description";
static NSString *kLinkStr         = @"link";
static NSString *kPubDateStr      = @"pubDate";
static NSString *kContactStr      = @"contactEmail";
static NSString *kReferenceStr    = @"reference";


@interface ParseOperation ()
@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) RssItem *workingEntry;
@property (nonatomic, strong) NSMutableString *workingPropertyString;
@property (nonatomic, strong) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
- (void)parse;
@end

@implementation ParseOperation

@synthesize delegate, cancel, returnQueue, workingArray, totalItems, totalAvailableItems;
@synthesize dataToParse, workingEntry, workingPropertyString, elementsToParse, storingCharacterData;

- (id)initWithData:(NSData *)data delegate:(NSObject<ParseOperationDelegate> *)theDelegate{
    self = [super init];
    if (self != nil){
        self.dataToParse = data;
        self.delegate = theDelegate;
        self.cancel = NO;
        
        NSArray *elementsArray = [[NSArray alloc] initWithObjects:kTitleStr, kDescriptionStr, kLinkStr, kPubDateStr, kContactStr, kReferenceStr, nil];
        
        self.elementsToParse = elementsArray;
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------

// -------------------------------------------------------------------------------
//	main:
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------
- (void)parseAsyncronous{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    returnQueue = dispatch_get_current_queue();
    
    dispatch_async(queue, ^{
        [self parse];
    });
}

- (void)parse{
	@autoreleasepool{
        
        self.cancel = NO;
		self.workingArray = [NSMutableArray array];
        self.workingPropertyString = [NSMutableString string];
    
        // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
            // desirable because it gives less control over the network, particularly in responding to
            // connection errors.
        
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
        [parser setDelegate:self];
        [parser setShouldProcessNamespaces:NO]; // We don't care about namespaces
        [parser setShouldReportNamespacePrefixes:NO]; //
        [parser setShouldResolveExternalEntities:NO]; // We just want data, no other stuff
        [parser parse];
            
            if (![self isCancelled]){
            //set all of the display titles from the standard titles.
            RssItem* currentItem;
            for(int i = 0; i < [workingArray count]; i++){
                currentItem = [workingArray objectAtIndex:i];
                currentItem.displayTitle = currentItem.title;
                
            }
            // notify our AppDelegate that the parsing is complete
                dispatch_sync(returnQueue, ^{
                    [delegate didFinishParsing:self];
                });
        }
        
        self.workingArray = nil;
        self.workingPropertyString = nil;
        self.dataToParse = nil;

	}
}

#pragma mark -
#pragma mark RSS processing
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict{
    if (![self isCancelled]){
        // entry: { id (link), im:name (app name), im:image (variable height) }
        if ([elementName isEqualToString:kEntryStr]){
            RssItem *newItem = [[RssItem alloc] init];
            self.workingEntry = newItem;
        }
        
        //clear the string in case last element was not used.
        [workingPropertyString setString:@""];
    }
    else{
        //operation queue has been cancelled so clear and abort parsing.
        self.workingEntry = nil;
        [parser abortParsing];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName{
    if (self.workingEntry){
        if ([elementsToParse containsObject:elementName]){
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [workingPropertyString setString:@""];  // clear the string for next time
            
            if ([elementName isEqualToString:kTitleStr]){
                self.workingEntry.title = trimmedString;
            }
            else if ([elementName isEqualToString:kDescriptionStr]){        
                self.workingEntry.description = trimmedString;
            }
            else if ([elementName isEqualToString:kLinkStr]){
                self.workingEntry.link = trimmedString;
            }
            else if ([elementName isEqualToString:kPubDateStr]){
                self.workingEntry.pubDate = trimmedString;
            }
            else if ([elementName isEqualToString:kContactStr]){
                self.workingEntry.contactEmail = trimmedString;
            }
            else if ([elementName isEqualToString:kReferenceStr]){
                self.workingEntry.referenceCode = trimmedString;
            }
        }
        else if ([elementName isEqualToString:kEntryStr]){
            [self.workingArray addObject:self.workingEntry];
            self.workingEntry = nil;
        }
    }
    else{
        if ([elementName isEqualToString:kTotalJobsStr]){
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            totalItems = [trimmedString intValue];
        }
        else if ([elementName isEqualToString:kTotalAvailableJobsStr]){
            NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            totalAvailableItems = [trimmedString intValue];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [workingPropertyString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    if (![self isCancelled]){
        dispatch_async(returnQueue, ^{
            [delegate parseErrorOccurred:parseError];
        });
    }
}

@end
