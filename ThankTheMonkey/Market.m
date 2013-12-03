//
//  Market.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Market.h"
#import "Business.h"
#import "Location.h"

@implementation Market

@synthesize name, geoCenterLat, geoCenterLon, radius;

-(CLRegion *)region
{
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([geoCenterLat doubleValue], [geoCenterLon doubleValue]);
    return [[CLRegion alloc] initCircularRegionWithCenter:coords radius:[radius doubleValue] identifier:name];
}

-(CLLocation *)centerPoint
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[self region].center.latitude longitude:[self region].center.longitude];
    return loc;
}

-(NSArray *)businesses
{
    return [Business findByColumn:@"marketId" doubleValue:primaryKey];
}

-(NSArray *)locations
{
    NSArray *marketBusinesses = [self businesses];
    NSMutableArray *allLocations = [[NSMutableArray alloc] init];
    for (Business *b in marketBusinesses){
        [allLocations addObjectsFromArray:[Location findByColumn:@"businessId" doubleValue:b.primaryKey]];
    }
    return [allLocations sortedArrayUsingSelector:@selector(compareByDistance:)];
}

-(MediaPartner *)mediaPartner
{
    return [[MediaPartner findByColumn:@"marketId" doubleValue:primaryKey] objectAtIndex:0];
}

+(id)getNearestFromLocation:(CLLocation *)location
{
    NSArray *markets = [Market findAll];
    double previousDistance = DBL_MAX;
    Market *closest;
    for (Market *m in markets){
        double distance = [[m centerPoint] distanceFromLocation:location];
        NSLog(@"Distance from current location to %@ is %f meters",m.name, distance);
        if (distance < previousDistance){
            previousDistance = distance;
            closest = m;
        }
    }
    return closest;
}

+(NSArray *)getMarketsWithinRadius:(CLLocationDistance)radius fromLocation:(CLLocation *)location;
{
    CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:location.coordinate radius:radius identifier:@"LocalArea"];
    NSArray *markets = [Market findAll];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Market *m in markets){
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([m.geoCenterLat doubleValue],[m.geoCenterLon doubleValue]);
        if ([region containsCoordinate:coord]){
            [results addObject:m];
        }
    }
    return results;
}

@end
