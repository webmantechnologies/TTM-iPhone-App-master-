//
//  NSString+Truncate.m
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Truncate.h"

#define ellipsis @"…"

@implementation NSString (Truncate)

- (NSString*)truncateToWidth:(CGFloat)width withFont:(UIFont *)font
{
    // Create copy that will be the returned result
    NSMutableString *truncatedString = [[self mutableCopy] autorelease];
    
    // Make sure string is longer than requested width
    if ([self sizeWithFont:font].width > width)
    {
        // Accommodate for ellipsis we'll tack on the end
        width -= [ellipsis sizeWithFont:font].width;
        
        // Get range for last character in string
        NSRange range = {truncatedString.length - 1, 1};
        
        // Loop, deleting characters until string fits within width
        while ([truncatedString sizeWithFont:font].width > width) 
        {
            // Delete character at end
            [truncatedString deleteCharactersInRange:range];
            
            // Move back another character
            range.location--;
        }
        
        // Append ellipsis
        [truncatedString replaceCharactersInRange:range withString:ellipsis];
    }
    
    return truncatedString;
}

@end
