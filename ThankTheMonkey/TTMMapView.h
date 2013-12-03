//
//  TTMMapView.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TTMMapAnnotation.h"

@interface TTMMapView : MKMapView <MKMapViewDelegate>
{
    NSMutableArray *locations,*businesses;
}

@property (nonatomic, retain) NSMutableArray *locations,*businesses;

-(void) setData:(NSArray *)data;

@end
