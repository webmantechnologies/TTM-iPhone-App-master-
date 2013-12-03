//
//  NSString+Truncate.h
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Truncate)

- (NSString*)truncateToWidth:(CGFloat)width withFont:(UIFont *)font;

@end
