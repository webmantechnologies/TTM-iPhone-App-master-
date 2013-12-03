//
//  TTMMapAnnotation.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMMapAnnotation.h"

@implementation TTMMapAnnotation
@synthesize coordinate, title, subtitle,category,description,location;

- (id) initWithDictionary:(NSDictionary *) dict
{
	self = [super init];
	if (self != nil) {
        self.title = [dict objectForKey:@"name"];
		self.subtitle = [dict objectForKey:@"address"];
        self.category=[dict objectForKey:@"category"];
		coordinate.latitude = [[dict objectForKey:@"latitude"] doubleValue];
		coordinate.longitude = [[dict objectForKey:@"longitude"] doubleValue];
        self.description=[dict objectForKey:@"description"];
	}
	return self;
}

-(id)initWithLocation:(Location *)loc
{
    self = [super init];
    if (self != nil){
        Business *b = [loc business];
        int numCoupons = [[b coupons] count];
        self.title = [NSString stringWithFormat:@"%@\n %d coupon%@", b.name, numCoupons,(numCoupons >1 ? @"s" : @"")];
        self.subtitle = loc.address;
        self.coordinate = CLLocationCoordinate2DMake([loc.latitude doubleValue], [loc.longitude doubleValue]);
        self.description = b.description;
        location = loc;
    }
    return self;
}

/*
- (id) initWithBusiness:(Business *)business
{
	self = [super init];
	if (self != nil) {
        self.title = business.name;
		self.subtitle = [business cl
        self.category=[dict objectForKey:@"category"];
		coordinate.latitude = [[dict objectForKey:@"latitude"] doubleValue];
		coordinate.longitude = [[dict objectForKey:@"longitude"] doubleValue];
        self.description=[dict objectForKey:@"description"];
	}
	return self;
}
*/

@end
