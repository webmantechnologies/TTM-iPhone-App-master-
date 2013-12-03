//
//  Business.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "MediaPartner.h"
#import "Market.h"
#import "OrderedDictionary.h"

@interface Business : ISModel
{
    NSString *name;
    NSString *imageName;
    NSString *description;
    NSString *website;
    NSNumber *businessType;
    NSNumber *mediaPartnerId;
    NSString *videoId;
}

@property (nonatomic, retain) NSString *name, *imageName, *description, *website, *videoId;
@property (nonatomic, retain) NSNumber *businessType, *mediaPartnerId;

+(NSArray *)getAllInMarket:(int)marketId withCoupons:(BOOL)withCoupons;
+(OrderedDictionary *)getAllInMarketByCategory:(int)marketId withCoupons:(BOOL)withCoupons;
-(Location *)closestFromLocation:(CLLocation *)location;
-(NSArray *)coupons;
-(NSArray *)locations;
-(MediaPartner *)mediaPartner;
//-(Market *)market;

@end
