//
//  TTMAppDelegate.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"
#import "Market.h"
#import "TTMListViewController.h"
#import "TTMMainViewController.h"
#import "TTMHelper.h"
#import "TTMCategoryViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UAirship.h"

@class ISDatabase;

extern NSString *const FBSessionStateChangedNotification;

@interface TTMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,CLLocationManagerDelegate>
{
    ProgressView *progressView;
    ISDatabase *database;
    CLLocation *currentLocation;
    CLLocationCoordinate2D currentLatLon;
    NSArray *businesses;
    TTMMainViewController *mainViewController;
    TTMListViewController *listViewController;
    TTMCategoryViewController *catViewController;
    UINavigationController *navController;
    UIToolbar *bottomBar;
    Market *currentMarket;
    UIImageView *waiting;
    
    UIBarButtonItem *flipButton, *searchButton;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) ProgressView *progressView;
@property (nonatomic, retain) ISDatabase *database;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D currentLatLon;
//@property (nonatomic, retain) NSArray *businesses;
@property (nonatomic, retain) TTMMainViewController *mainViewController;
@property (nonatomic, retain) TTMListViewController *listViewController;
@property (nonatomic, retain) TTMCategoryViewController *catViewController;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) UIBarButtonItem *flipButton, *searchButton;
@property (nonatomic, retain) UIToolbar *bottomBar;
@property (nonatomic, retain) Market *currentMarket;
@property (nonatomic, retain) UIImageView *waiting;

- (void)initDatabase;
- (void)finishedUpdatingDatabase;
//- (void)openSession;

@end
