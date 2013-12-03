//
//  Business.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Business.h"
#import "BusinessType.h"
#import "Coupon.h"
#import "OrderedDictionary.h"

@implementation Business

@synthesize name, imageName, description, website, businessType, mediaPartnerId,videoId;

+(NSArray *)getAllInMarket:(int)marketId withCoupons:(BOOL)withCoupons
{
    MediaPartner *mp = [[MediaPartner findByColumn:@"marketId" doubleValue:marketId] objectAtIndex:0];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * from Business where Business.mediaPartnerId = %d",mp.primaryKey];
    NSArray *businesses = [self findWithSql:query];
    if (!withCoupons) {
        return businesses;
    }else{
        for (Business *b in businesses){
            if ([[b coupons] count] > 0 ){
                if (b.imageName==@"" || b.imageName==NULL)
                    b.imageName=@"monkey.png";
                [results addObject:b];
            }
        }
        return results;
    }
}

+(OrderedDictionary *)getAllInMarketByCategory:(int)marketId withCoupons:(BOOL)withCoupons
{
    MediaPartner *mp = [[MediaPartner findByColumn:@"marketId" doubleValue:marketId] objectAtIndex:0];
    OrderedDictionary *results = [[OrderedDictionary alloc] init];
    OrderedDictionary *sortedResults = [[OrderedDictionary alloc] init];
    NSString *query = [NSString stringWithFormat:@"SELECT * from Business where mediaPartnerId = %d",mp.primaryKey];
    NSArray *businesses = [self findWithSql:query];
    for (Business *b in businesses){
        NSLog(@"%@",b.name);
        if ([[b coupons] count] > 0){
            BusinessType *cat = [BusinessType find:[b.businessType intValue]];
            if (![results objectForKey:cat.name]){
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [results setObject:arr forKey:cat.name];
            }
            [[results objectForKey:cat.name] addObject:b];
        }
    }
    NSArray *sortedKeys = [results keysSortedByValueUsingComparator: ^(NSArray *obj1, NSArray *obj2) {
        
        if ([obj1 count] > [obj2 count]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if ([obj1 count] < [obj2 count]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    for (NSString *key in sortedKeys){
        [sortedResults setObject:[results objectForKey:key] forKey:key];
    }
    return sortedResults;
}

-(NSArray *)coupons
{
    //change this thing get the real coupons
    //NSString *query = [NSString stringWithFormat:@"SELECT * from Coupon where mediaPartnerId = %d",mp.primaryKey];
    return [Coupon findByColumn:@"businessId" doubleValue:self.primaryKey];
}

-(NSArray *)locations
{
    return [Location findByColumn:@"businessId" doubleValue:self.primaryKey];
}

-(Location *)closestFromLocation:(CLLocation *)location
{
    NSArray *testLocs = [Location findAll];
    //NSLog(@"Num locations TOTAL: %d",[testLocs count]);
    NSArray *locations = [Location findByColumn:@"businessId" doubleValue:self.primaryKey];
    //NSLog(@"How many locations for this business?  %d",[locations count]);
    CLLocationDistance previousDistance = DBL_MAX;
    Location *closest;
    for (Location *l in locations){
        CLLocation *next = [[CLLocation alloc] initWithLatitude:[l.latitude doubleValue] longitude:[l.longitude doubleValue]];
        //NSLog(@"%@",next);
        //NSLog(@"lPassed: %@",location);
        CLLocationDistance distance = [next distanceFromLocation:location];
        //NSLog(@"Distance from current location to %@ is %f meters",l.address, distance);
        if (distance < previousDistance){
            previousDistance = (double)distance;
            closest = l;
        }
    }
    return closest;
}

-(MediaPartner *)mediaPartner
{
    MediaPartner *mp = [MediaPartner find:[self.mediaPartnerId intValue]];
    return mp;
}

/*
-(Market *)market
{
    Market *m = [[Market findByColumn:@"marketId" doubleValue:[mediaPartnerId doubleValue]] objectAtIndex:0];
    return m;
}
 */
                                
@end
