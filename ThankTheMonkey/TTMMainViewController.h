//
//  TTMMainViewController.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TTMMapView.h"

@interface TTMMainViewController : UIViewController <MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    TTMMapView *mainMapView;
    UITableView *mainTableView;
    NSMutableArray *locations,*businesses;
    NSMutableDictionary *images;
    UIBarButtonItem *flipButton;
}

@property (nonatomic, retain) TTMMapView *mainMapView;
@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *locations,*businesses;
@property (nonatomic, retain) UIBarButtonItem *flipButton;

-(void) setData:(NSArray *)data;
-(void) setMapRegion:(CLLocationCoordinate2D)location;
-(void) flipMap;

@end
