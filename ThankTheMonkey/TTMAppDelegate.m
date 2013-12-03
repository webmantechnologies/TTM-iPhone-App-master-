//
//  TTMAppDelegate.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMAppDelegate.h"
#import "TTMCategoryViewController.h"
#import "TTMListViewController.h"
#import "Business.h"
#import "Market.h"
#import "AppDatabase.h"
#import "TTMHelper.h"

@implementation TTMAppDelegate
@synthesize waiting;
@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize progressView;
@synthesize database;
@synthesize currentLocation;
@synthesize currentLatLon;
@synthesize currentMarket;
@synthesize listViewController, mainViewController,catViewController;
@synthesize navController;
@synthesize flipButton, searchButton;
@synthesize bottomBar;

CLLocationManager *locManager;
int locationUpdateCount = 0;

NSString *const FBSessionStateChangedNotification =
@"com.w2winnovations.thankthemonkey:FBSessionStateChangedNotification";

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

// If we have a valid session at the time of openURL call, we handle Facebook transitions
// by passing the url argument to handleOpenURL; see the "Just Login" sample application for
// a more detailed discussion of handleOpenURL
- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url]; 
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    //Register for notifications
	[[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    [UAirship takeOff:takeOffOptions];*/
    
    [self initDatabase];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ttm_background.png"]];
    mainViewController = [[TTMMainViewController alloc] initWithNibName:@"TTMMainViewController" bundle:nil];
    catViewController = [[TTMCategoryViewController alloc] initWithNibName:@"TTMCategoryViewController" bundle:nil];
    listViewController = [[TTMListViewController alloc] initWithNibName:@"TTMListViewController" bundle:nil];
   
    
    navController = [[UINavigationController alloc] initWithRootViewController:self.catViewController];
    navController.navigationBar.tintColor = [UIColor orangeColor];
    navController.title = @"Thank the Monkey";
    
    searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    navController.topViewController.navigationItem.leftBarButtonItem = searchButton;
    
    [navController setToolbarHidden:NO];
    navController.toolbar.tintColor = [UIColor orangeColor];
    //[self setToolbarItems:things];
    
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    NSLog(@"just set location manager delegate");
    currentLocation = [[CLLocation alloc] init];
    //[locManager startUpdatingLocation];
    
    //[listViewController setData:businesses];
    //self.window.rootViewController = self.navController;
    
    //[self.window makeKeyAndVisible];
    waiting = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    waiting.frame = [[UIScreen mainScreen] applicationFrame];
    [self.window addSubview:waiting];
    progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 416-48, 320, 48)];
    [progressView.progressLabel setText:@"Finding Coupons Near You..."];
    [progressView setHidden:TRUE];
    [self.window addSubview:progressView];
    [self.window makeKeyAndVisible];
    
    // FACEBOOK STUFF
    /*
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    */
    
    return YES;
}

- (void) finishedUpdatingDatabase
{
    [progressView setHidden:TRUE];
    [locManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    locationUpdateCount++;
    NSLog(@"Ok, location has UPDATED %d times",locationUpdateCount);
    if (locationUpdateCount > 2){
        [locManager stopUpdatingLocation];
        currentLocation = newLocation;
        currentLatLon = newLocation.coordinate;
        Market *closest = [Market getNearestFromLocation:currentLocation];
        currentMarket = closest;
        MediaPartner *mp = [[MediaPartner findByColumn:@"marketId" doubleValue:closest.primaryKey] objectAtIndex:0];
    
        NSLog(@"Closest market is %@",closest.name);
        businesses = [Business getAllInMarket:closest.primaryKey withCoupons:TRUE];
        NSLog(@"Found (%d) local businesses with coupons",[businesses count]);
        //[listViewController setData:businesses];
        NSArray *categories = [BusinessType findAll];
        OrderedDictionary *bDict = [Business getAllInMarketByCategory:closest.primaryKey withCoupons:TRUE];
        [bDict insertObject:mp forKey:@"MediaPartner" atIndex:0];
        [catViewController setCategories:categories withBusinesses:bDict];
        if (waiting != nil){
            [waiting removeFromSuperview];
            [waiting release];
            waiting = nil;
        }
        self.window.rootViewController = self.navController;
        [self.window makeKeyAndVisible];
        NSLog(@"Done doing location update shit.");
    }
}

- (void)initDatabase {
    if (self.database == nil) {
        NSLog(@"Initializing database...");
        self.database = [[AppDatabase alloc] init];
    }
}

/*
- (void)sessionStateChanged:(FBSession *)session 
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = 
            [self.navController topViewController];
            if ([[topViewController modalViewController] 
                 isKindOfClass:[SCLoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to 
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }    
}

- (void)openSession
{
    [FBSession openActiveSessionWithPermissions:nil
                                   allowLoginUI:YES
                              completionHandler:
     ^(FBSession *session, 
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];    
}
 */

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [locManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // if the app is going away, we close the session object
    [UAirship land];
    [FBSession.activeSession close];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAirship shared] registerDeviceToken:deviceToken];
}

@end
