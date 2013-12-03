//
//  TTMMapView.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMMapView.h"
#import "Location.h"
#import "Business.h"
#import "BusinessViewController.h"
#import "TTMAppDelegate.h"

@implementation TTMMapView

-(id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 480-44)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.showsUserLocation = TRUE;
    }
    return self;
}

-(void) setData:(NSArray *)data
{
    locations = [[NSMutableArray alloc] init];
    businesses = [[NSMutableArray alloc] initWithArray:data];
    NSRange bRange = NSMakeRange(1, [businesses count] - 1);
    for (Business *b in [businesses subarrayWithRange:bRange]){
        NSArray *bLocations = [b locations];
        for (Location *l in bLocations){
            //NSLog(@"Location address: %@",l.address);
            TTMMapAnnotation *ann = [[TTMMapAnnotation alloc] initWithLocation:l];
            NSLog(@"Adding annotation: %@",ann.title);
            [self addAnnotation:ann];
            [locations addObject:ann];
            NSLog(@"locations array now has %d items",[locations count]);
        }
    }
    NSLog(@"B# locations: %d",[locations count]);
    NSLog(@"B# annotations: %d", [self.annotations count]);
}

#pragma mark - Map delegate

/**
 MapView delegate. This function put the pins of the selected category in the map. This function is call when someone click in the pin and show the information about the pin. This informacion contain the name of the shop/restaurante.. and the address. This method return the information about the pin like the location and name.
 */

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	
	if (mapView.userLocation == annotation){
		return nil;
	}
	NSString *identifier = @"MY_IDENTIFIER";
	
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (annotationView == nil){
		annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation 
													   reuseIdentifier:identifier] 
						  autorelease];
        MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil ]autorelease];        
        
        
        pinView.pinColor=MKPinAnnotationColorRed;
        
        
        pinView.canShowCallout=YES;
        annotationView=pinView;
		annotationView.canShowCallout = YES;
		
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
		
	}
	return annotationView;
}

/**
 This method is used to go fron your current location to the point that you select before. The system give an alert to say that the application is going to close and it is going to open google maps.
 */

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BusinessViewController *bvc = [[BusinessViewController alloc] init];
    TTMMapAnnotation *auxAnnotation = view.annotation;
    Business *b = [auxAnnotation.location business];
    [bvc setBusinessData:b];
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController pushViewController:bvc animated:TRUE];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
