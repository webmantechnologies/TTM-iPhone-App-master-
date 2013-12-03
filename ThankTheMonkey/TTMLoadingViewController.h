//
//  TTMLoadingViewController.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDatabase.h"
#import "ProgressView.h"
#import "TTMCategoryViewController.h"
#import "TTMHelper.h"
#import "Market.h"
#import <CoreLocation/CoreLocation.h>

@interface TTMLoadingViewController : UIViewController <CLLocationManagerDelegate,AppDatabaseDelegate>
{
    ProgressView *progressView;
    ISDatabase *database;
    CLLocation *currentLocation;
    CLLocationCoordinate2D currentLatLon;
    NSArray *businesses;
    TTMCategoryViewController *catViewController;
    UINavigationController *navController;
    Market *currentMarket;
    
    UIBarButtonItem *flipButton, *searchButton;
}

@property (nonatomic, retain) ProgressView *progressView;
@property (nonatomic, retain) ISDatabase *database;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D currentLatLon;
//@property (nonatomic, retain) NSArray *businesses;
@property (nonatomic, retain) TTMCategoryViewController *catViewController;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UIBarButtonItem *flipButton, *searchButton;
@property (nonatomic, retain) Market *currentMarket;

@end
