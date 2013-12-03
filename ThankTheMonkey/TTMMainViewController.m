//
//  TTMMainViewController.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMMainViewController.h"
#import "Business.h"
#import "BusinessTableData.h"
#import "BusinessTableViewCell.h"
#import "MediaPartnerTableViewCell.h"
#import "BusinessViewController.h"
#import "TTMAppDelegate.h"
#import "TTMMapAnnotation.h"
#import "TTMHelper.h"
#import "WebsiteViewController.h"
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface TTMMainViewController ()

@end

@implementation TTMMainViewController

@synthesize mainMapView, mainTableView, businesses, locations, flipButton;

BOOL displayingPrimary = TRUE;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

   
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float == 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
	// Do any additional setup after loading the view.
    //self.title = @"Thank The Monkey";
    flipButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(flipMap)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = flipButton;
    
    UILabel *marketName = [[UILabel alloc] initWithFrame:CGRectMake(0, 372, 320, 44)];
    marketName.font = [UIFont boldSystemFontOfSize:18];
    marketName.backgroundColor = [UIColor clearColor];
    marketName.textAlignment = UITextAlignmentCenter;
    marketName.textColor = [UIColor whiteColor];
    marketName.shadowColor = [UIColor blackColor];
    marketName.shadowOffset = CGSizeMake(1, 1);
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    marketName.text = del.currentMarket.name;
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:marketName];
    NSArray *things = [NSArray arrayWithObjects:labelItem, nil];
    [self setToolbarItems:things];

    self.view.backgroundColor = [UIColor clearColor];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 375) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.backgroundColor=[UIColor clearColor];
    //mainTableView.tableHeaderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wtrf.png"]];
    //mainTableView.layer.cornerRadius = 8;
    mainTableView.clipsToBounds = TRUE;
    
    /*
    mainMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-44)];
    mainMapView.delegate = self;
    mainMapView.showsUserLocation = TRUE;
     */
     
    [self setMapRegion:del.currentLatLon];
    
    mainMapView.hidden = TRUE;

    [self.view addSubview:mainMapView];
    [self.view addSubview:mainTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:FALSE animated:YES];
    /*
    int i;
    for (i=0; i<[locations count]; i++)
    {
        TTMMapAnnotation *annotation = (TTMMapAnnotation*)[locations objectAtIndex:i];
        [mainMapView addAnnotation:annotation];
    }
     */
    //mainMapView.hidden = FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setMapRegion:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    //NSLog(@"Current lat/lon: %f, %f", location.latitude, location.longitude);
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [mainMapView setRegion:region];
}

-(void) flipMap
{
    [flipButton setTitle:(displayingPrimary ? @"List" : @"Map")];
    NSLog(displayingPrimary ? @"DISPLAYING List" : @"DISPLAYIN Map");
    mainMapView.hidden = (displayingPrimary ? FALSE : TRUE);
    //NSLog(@"# locations: %d",[locations count]);
    //NSLog(@"# annotations: %d", [mainMapView.annotations count]);
    [UIView transitionFromView:(displayingPrimary ? mainTableView : mainMapView)
                        toView:(displayingPrimary ? mainMapView : mainTableView)
                      duration:0.5
                       options:(displayingPrimary ? 
                                UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        if (finished) {
                            displayingPrimary = !displayingPrimary;
                        }
                    }
     ];
}

-(void) setData:(NSArray *)data
{
    mainMapView = [[TTMMapView alloc] init];
    locations = [[NSMutableArray alloc] init];
    businesses = [[NSMutableArray alloc] initWithArray:data];
    
    [mainMapView setData:businesses];
    [self.mainTableView reloadData];
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
    [[self navigationController] pushViewController:bvc animated:TRUE];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [businesses count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"MPCell";

    if (indexPath.row == 0){
        MediaPartner *mp = [businesses objectAtIndex:0];
        MediaPartnerTableViewCell *cell = (MediaPartnerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[MediaPartnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        [cell setMpImage:[TTMHelper getImageFromName:mp.bannerName]];
        return cell;
    }else{
        BusinessTableViewCell *cell = (BusinessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[BusinessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
        }
        
        cell.backgroundColor=[UIColor clearColor];
        
        BusinessTableData *business = [businesses objectAtIndex:indexPath.row];
        
        //cell.textLabel.font = [UIFont boldSystemFontOfSize:14];// systemFontOfSize:16];
        //cell.textLabel.textColor = [[UIColor alloc] initWithRed:0.25 green:0.4 blue:0.5 alpha:1.0];
        //[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        /*
         cell.detailTextLabel.textColor = [UIColor blackColor];
         cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
         cell.textLabel.numberOfLines=2;
         cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
         */
        cell.titleLabel.text = [NSString stringWithFormat:@"%@\n",business.name];
        NSString *numCoupons = [NSString stringWithFormat:@"(%d coupons)",[[business coupons] count]];
        cell.subTitleLabel.text = numCoupons;
        
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *distance = [NSString stringWithFormat:@"(%@mi)",[formatter stringFromNumber:business.distance]];
        cell.infoLabel.text = distance;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageBaseName;
        NSString *imageName;
        if (![business.imageName isEqualToString:@""] && !(business.imageName == NULL)){
            NSRange match;
            NSString *imageBaseName;
            
            match = [business.imageName rangeOfString: @"/"];
            if (match.location == 0)
                imageBaseName = business.imageName;
            else{
                imageBaseName = [business.imageName substringFromIndex:match.location + 1];
                match = [imageBaseName rangeOfString:@"/"];
                if (match.length != 0)
                {
                    imageBaseName = [imageBaseName substringFromIndex:match.location + 1];
                }
            }
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            
            NSString *documentsFolder = [paths objectAtIndex:0];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsFolder stringByAppendingPathComponent:imageBaseName]]) {
                [[cell imageView] setImage:[UIImage imageWithContentsOfFile: [documentsFolder stringByAppendingPathComponent:imageBaseName]]];
            }
            else
            {
                [cell.imageView setImage:[UIImage imageNamed:@"monkeyBW.png"]];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                
                UIImage *image;
                NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:business.imageName]]];
                image = [[UIImage alloc] initWithData:receivedData];
                NSData *pngFile = UIImagePNGRepresentation(image);
                NSLog(@"MP image is %@", imageBaseName);
                NSLog(@"MP full image is %@",[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:business.imageName]);
                
                //NSLog(@"to be copied to %@", documentsFolder);
                [pngFile writeToFile:[documentsFolder stringByAppendingPathComponent:imageBaseName] atomically:YES];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[cell imageView] setImage:image];
                    [cell setNeedsLayout];
                });
            });
            }
            /*NSRange match;
            
            match = [business.imageName rangeOfString: @"/"];
            if (match.location == NSNotFound)
                imageName = business.imageName;
            else{
                imageBaseName = [business.imageName substringFromIndex:match.location + 1];
                match = [imageBaseName rangeOfString:@"/"];
                if (match.location != NSNotFound)
                {
                    imageBaseName = [imageBaseName substringFromIndex:match.location + 1];
                }
                }
            if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsFolder stringByAppendingPathComponent:imageBaseName]]) {
                [[cell imageView] setImage:[UIImage imageWithContentsOfFile: [documentsFolder stringByAppendingPathComponent:imageBaseName]]];
            }
            else{
                [cell.imageView setImage:[UIImage imageNamed:@"monkeyBW.png"]];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *documentsFolder = [paths objectAtIndex:0];
                    UIImage *image;
                        NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:business.imageName]]];
                        UIImage *unresizedImage = [[UIImage alloc] initWithData:receivedData];
                        image = unresizedImage;//[self resizeImage:unresizedImage imageWidth:75 imageHeight:75];
                        NSData *pngFile = UIImagePNGRepresentation(unresizedImage);
                        NSLog(@"Business image is %@", imageName);
                        
                        //NSLog(@"to be copied to %@", documentsFolder);
                        [pngFile writeToFile:[documentsFolder stringByAppendingPathComponent:imageName] atomically:YES];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[cell imageView] setImage:image];
                    [cell setNeedsLayout];
                });
            });
                
            }*/
        }
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        MediaPartner *mp = [businesses objectAtIndex:indexPath.row];
        WebsiteViewController *siteViewController = [[WebsiteViewController alloc] init];
        siteViewController.title = mp.name;
        siteViewController.url = mp.website;
        [siteViewController showWebsite];
           [self.view setAlpha:0.0f];
        [self.navigationController pushViewController:siteViewController animated:TRUE];
    }else {
        BusinessViewController *businessViewController = [[BusinessViewController alloc] init];
        [businessViewController setBusinessData:[businesses objectAtIndex:indexPath.row]];
           [self.view setAlpha:0.0f];
        [self.navigationController pushViewController:businessViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{     [super viewWillAppear:animated];
    [self.view setAlpha:1.0f];
    
    
}
@end
