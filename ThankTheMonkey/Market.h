//
//  Market.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"
#import <CoreLocation/CoreLocation.h>
#import "MediaPartner.h"

@interface Market : ISModel
{
    NSString *name;
    NSString *geoCenterLat;
    NSString *geoCenterLon;
    NSNumber *radius;
}

@property (nonatomic, retain) NSString *name, *geoCenterLat, *geoCenterLon;
@property (nonatomic, retain) NSNumber *radius;

+(id)getNearestFromLocation:(CLLocation *)location;
+(NSArray *)getMarketsWithinRadius:(CLLocationDistance)radius fromLocation:(CLLocation *)location;
-(MediaPartner *)mediaPartner;
-(CLRegion *)region;
-(NSArray *)businesses;
-(NSArray *)locations;

@end
