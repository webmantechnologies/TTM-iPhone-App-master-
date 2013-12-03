//
//  TTMMapAnnotation.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface TTMMapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
    NSString *category;
    NSString *description;
    Location *location;
}

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, retain) Location *location;

-(id)initWithLocation:(Location *)loc;


@end
