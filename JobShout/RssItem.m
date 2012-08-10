//
//  RssItem.m
//  JobShout
//
//  Created by Liam Flynn on 18/05/2011.
//  Copyright 2011 aaa. All rights reserved.
//

#import "RssItem.h"

@implementation RssItem

@synthesize title, description, link, pubDate, displayTitle, referenceCode, contactEmail;


- (void)setDisplayTitle:(NSString *)originalTitle{
    //set the standard title and this function works out the display title.
    
    @autoreleasepool {
    
        
        NSMutableString *workingTitle = [[NSMutableString alloc] init];
        
        //use placement of certain characters (above) and length of string to semi-intelligently cut the string down.
        NSRange closestPosition = NSMakeRange(0, 80);
        
        NSArray *searchArray = [[NSArray alloc] initWithObjects:@"- ", @" -", @" +",@"|", @"(", @")", @".", @"www", @"http", @"\n", @" X ", @"  ", nil];
        NSRange currentRange;
        
        for(NSUInteger i = 0; i < [searchArray count]; i++){
            
             currentRange = [originalTitle rangeOfString:[searchArray objectAtIndex:i]];
            
            if(currentRange.location != NSNotFound){
                //if it can be trimmed shorter then do so but only if satisfies minimum
                if(closestPosition.length > currentRange.location && currentRange.location > 5){
                    closestPosition.length = currentRange.location;
                }
            }
        }
        
        
        //will trim to starting length if can not be more intelligently cropped.
        if([originalTitle length] > closestPosition.length){
            [workingTitle setString:[originalTitle substringWithRange:closestPosition]];
        }
        else{
            [workingTitle setString:originalTitle];
        }
        
        //capitalise just first letter, do no use capitalize as things like SEO change to Seo - incorrect.
        
        NSMutableArray *wordArray = [[workingTitle componentsSeparatedByString:@" "] mutableCopy];
        NSString *currentWord;

        for(NSUInteger j = 0; j < [wordArray count]; j++){
            currentWord = [wordArray objectAtIndex:j];
            //capitalise the first letter of each word.
            if([currentWord length] > 0){
                [wordArray replaceObjectAtIndex:j withObject:[currentWord stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[currentWord substringToIndex:1] uppercaseString]]];
            }
        }
        
        NSString *capitalisedTitle = [wordArray componentsJoinedByString:@" "];

        displayTitle = capitalisedTitle;
        
    
    }
}

@end

