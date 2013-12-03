//
//  Location.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Location.h"
#import "TTMAppDelegate.h"
#import "Business.h"

@implementation Location

@synthesize businessId, phone, address, latitude, longitude;

-(CLLocation *)geoLocation{
    NSLog(@"Creating CLLocation from latitude: %f and longitude: %f",[latitude doubleValue], [longitude doubleValue]);
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    return loc;
}

- (NSComparisonResult)compareByDistance:(Location *)loc
{
    
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
	CLLocationDistance d1 = [[self geoLocation] distanceFromLocation:del.currentLocation];
    CLLocationDistance d2 = [[loc geoLocation] distanceFromLocation:del.currentLocation];
	if (d1 > d2)
	{
		return NSOrderedDescending;
	}
    
	if (d2 > d1)
	{
		return NSOrderedAscending;
	}
    
	return NSOrderedSame;
}

-(Business *)business
{
    Business *b = [Business find:[businessId intValue]];
    return b;
}

@end
