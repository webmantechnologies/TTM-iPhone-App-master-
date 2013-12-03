//
//  BusinessType.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessType.h"
#import "Business.h"

@implementation BusinessType

@synthesize name, mediaPartnerId, imageName;

-(NSArray*)businesses
{
    NSArray *tmp = [Business findByColumn:@"businessType" doubleValue:self.primaryKey];
    return tmp;
}

@end
