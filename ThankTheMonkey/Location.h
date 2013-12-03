//
//  Location.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"
#import <CoreLocation/CoreLocation.h>


@class Business;

@interface Location : ISModel
{
    NSNumber *businessId;
    NSString *phone;
    NSString *address;
    NSString *latitude;
    NSString *longitude;
}

@property (nonatomic, retain) NSNumber *businessId;
@property (nonatomic, retain) NSString *phone, *address, *latitude, *longitude;

-(CLLocation *)geoLocation;
- (NSComparisonResult)compareByDistance:(Location *)loc;
-(Business *)business;

@end
