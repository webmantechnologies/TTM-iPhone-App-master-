//
//  BusinessViewController.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessViewController.h"
#import "TTMHelper.h"
#import "TTMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CouponTableViewCell.h"
#import "MediaPartner.h"
#import "CouponView.h"
#import "CouponImageView.h"
#import "WebsiteViewController.h"
#import "RegexKitLite.h"
#import "TTMTitleView.h"
//#import "GData.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MKPlacemark.h>

@interface BusinessViewController ()

@end

@implementation BusinessViewController

@synthesize businessView;
@synthesize image, videoBtn, mapBtn;
@synthesize name, address, phone, website, description;
@synthesize business;
@synthesize optionsButton;
@synthesize couponsTable,coupons;//,scrollView;
@synthesize descriptionView;
@synthesize overlay, couponView, closeButton;
@synthesize youtube;

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
    
    // Do any additional setup after loading the view from its nib.
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:del.currentLatLon.latitude longitude:del.currentLatLon.longitude];
    closest = [business closestFromLocation:currentLoc];
    
    [self.navigationController setToolbarHidden:TRUE animated:YES];
    
    TTMTitleView *titleView = [[TTMTitleView alloc] init];
    self.navigationItem.titleView = titleView;
    
    //CGRect sFrame = scrollView.frame;
    //sFrame.origin.y = 52;
    //scrollView.frame = sFrame;
    UIImage *bImage = [TTMHelper getImageFromName:business.imageName];
    double scaleFactor = 128 / bImage.size.width;
    image = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 128, bImage.size.height * scaleFactor)];
    [image setImage:bImage];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    image.layer.shadowColor = [UIColor blackColor].CGColor;
    image.layer.shadowRadius = 2.0;
    image.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    image.layer.shadowOpacity = 1.0;
    image.clipsToBounds = FALSE;
    name = [[UILabel alloc] initWithFrame:CGRectMake(142, 4, 148,32)];
    [name setFont:[UIFont systemFontOfSize:14]];
    name.adjustsFontSizeToFitWidth = YES;
    name.backgroundColor = [UIColor clearColor];
    name.text = business.name;
    address = [[UILabel alloc] initWithFrame:CGRectMake(142, 36, 148, 40)];
    address.numberOfLines = 2;
    address.backgroundColor = [UIColor clearColor];
    [address setFont:[UIFont systemFontOfSize:10]];
    address.text = closest.address;
    
    
    website = [[UIButton alloc] initWithFrame:CGRectMake(142,76, 148, 20)];
    website.backgroundColor = [UIColor clearColor];
    [website setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [website setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    website.titleLabel.font = [UIFont systemFontOfSize:10];
    [website setTitle:business.website forState:UIControlStateNormal];
    [website addTarget:self action:@selector(showWebsite) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [business.description sizeWithFont:[UIFont systemFontOfSize:14]
                                   constrainedToSize:CGSizeMake(304, MAXFLOAT)
                                       lineBreakMode:UILineBreakModeWordWrap];
    float height;
    if (image.frame.size.height + 8 < 94){
        height = 94;
    }else{
        height = image.frame.size.height + 8;
    }
    description = [[UILabel alloc] initWithFrame:CGRectMake(4, height, 286, 128)];
    [description  setFont:[UIFont systemFontOfSize:12]];
    [description setText:business.description];
    description.userInteractionEnabled = FALSE;
    description.numberOfLines = 0;
    [description sizeToFit];
    if (description.frame.size.height > 128){
        CGRect frame = description.frame;
        frame.size.height = 128;
        description.frame = frame;
    }
    description.backgroundColor = [UIColor clearColor];
    
    CGRect frame = description.frame;
    frame.size.width+=304;
    frame.size.height+=18;
    frame.origin.x-=9;
    frame.origin.y-=9;
    descriptionView = [[UIImageView alloc] initWithFrame:frame];
    descriptionView.opaque = TRUE;
    descriptionView.backgroundColor = [UIColor clearColor];
    
    /*
    description = [[UILabel alloc] initWithFrame:CGRectMake(4, image.frame.size.height + 8, 296, 128)];
    description.backgroundColor = [UIColor clearColor];
    [description setFont:[UIFont systemFontOfSize:10]];
    description.numberOfLines = 0;
    [description setLineBreakMode:UILineBreakModeWordWrap];
    description.text = business.description;
    */
    
    videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, description.frame.size.height + description.frame.origin.y + 4, 42, 42)];
    [videoBtn setImage:[UIImage imageNamed:@"video.png"] forState:UIControlStateNormal];
    [videoBtn addTarget:self action:@selector(showVideo) forControlEvents:UIControlEventTouchUpInside];
    [videoBtn setTag:1];
    
    mapBtn = [[UIButton alloc] initWithFrame:CGRectMake(52, description.frame.size.height + description.frame.origin.y + 4, 42, 42)];
    [mapBtn setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(showDirections) forControlEvents:UIControlEventTouchUpInside];
    
    phone = [[UIButton alloc] initWithFrame:CGRectMake(102, description.frame.size.height + description.frame.origin.y + 4, 202, 40)];
    phone.backgroundColor = [UIColor clearColor];
    [phone setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [phone setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    phone.titleLabel.textAlignment = UITextAlignmentCenter;
    phone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [phone setTitle:closest.phone forState:UIControlStateNormal];
    [phone addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];

    
    businessView = [[UIView alloc] initWithFrame:CGRectMake(8, 4, 304, height + 8 + description.frame.size.height + videoBtn.frame.size.height)];
    businessView.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.85 alpha:1.0];
    businessView.layer.cornerRadius = 8;
    businessView.clipsToBounds = FALSE;
    
    [businessView addSubview:image];
    [businessView addSubview:name];
    [businessView addSubview:address];
    [businessView addSubview:phone];
    [businessView addSubview:website];
    //[businessView addSubview:descriptionView];
    [businessView addSubview:description];
    [businessView addSubview:videoBtn];
    [businessView addSubview:mapBtn];
    
    couponsTable = [[UITableView alloc] initWithFrame:CGRectMake(8, businessView.frame.origin.y+businessView.frame.size.height + 10, 304, 128)];
    [couponsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    couponsTable.backgroundColor = [UIColor clearColor];
    [couponsTable setScrollEnabled:TRUE];
    couponsTable.layer.cornerRadius = 8.0;
    couponsTable.clipsToBounds = FALSE;
    couponsTable.delegate = self;
    couponsTable.dataSource = self;
    
    //[scrollView addSubview:businessView];
    //[scrollView addSubview:couponsTable];
    [self.view addSubview:couponsTable];
    [self.view addSubview:businessView];
    NSLog(@"Scrollview height: %f", couponsTable.frame.origin.y + couponsTable.contentSize.height + 40);
    NSLog(@"Tableview content height: %f, tableview origin: %f",couponsTable.contentSize.height, couponsTable.frame.origin.y);
    //[scrollView setContentSize:CGSizeMake(320, businessView.frame.size.height + ([coupons count]*62) + 88)];
}

-(void)viewDidAppear:(BOOL)animated
{
    /*
    couponsTable.layer.cornerRadius = 8;
    CGRect frame = couponsTable.frame;
    frame.origin.y = businessView.frame.size.height + 10;
    NSLog(@"table origin: %f",frame.origin.y);
    couponsTable.frame = frame; 
     */
}

-(NSString *)formatPhone:(NSString *)phoneNum
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setPositiveFormat:@"+# (###) ###-###"];
    [formatter setLenient:YES];
    NSString *strDigits = [phoneNum stringByReplacingOccurrencesOfRegex:@"[^0-9+]" withString:@""];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:[strDigits doubleValue]]];
	
    //[formatter setPositiveFormat:@"+# (###) ###-####"];
}

-(void)makeCall
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.frame];
        NSLog(@"formatted phone number: %@",[self formatPhone:closest.phone]);
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[self formatPhone:closest.phone]]]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}

-(void)showWebsite
{
        //[self checkNetwork];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];// autorelease];
        av.frame=CGRectMake(145, 230, 25, 25);
        av.tag  = 1;
        WebsiteViewController *websiteViewController = [[WebsiteViewController alloc] init];
        [websiteViewController.view addSubview:av];
        [av startAnimating];	
        [[self navigationController] pushViewController:websiteViewController animated:YES];
        
        NSURL *url = [NSURL URLWithString:business.website];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [websiteViewController.webView loadRequest:request];
}

-(void)showDirections
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Go to that location" message:@"This will open the Maps App" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex!=0)
    {
        TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
        //first create latitude longitude object
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(del.currentLatLon.latitude,del.currentLatLon.longitude);
        //create MKMapItem out of coordinates
        MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
        if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://maps.apple.com/maps?daddr=%@,%@&saddr=%f,%f", closest.latitude, closest.longitude,del.currentLatLon.latitude, del.currentLatLon.longitude]];
            [[UIApplication sharedApplication] openURL:url];
            
             [closeButton removeFromSuperview];
        }
        else
        {
            NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%@,%@&output=dragdir",del.currentLatLon.latitude,del.currentLatLon.longitude,closest.latitude,closest.longitude];
            NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
            NSLog(@"Should be opening Google Maps: %@",urlString);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
        }
    }
}

-(void)showVideo
{
    CGRect frame = CGRectMake(8, 460, 304, 228);
    if(youtube == nil) {
        youtube = [[UIWebView alloc] initWithFrame:frame];
        youtube.layer.cornerRadius = 8.0;
        youtube.layer.borderColor = [UIColor blackColor].CGColor;
        youtube.layer.borderWidth = 1;
        youtube.clipsToBounds = TRUE;
        [self.view addSubview:youtube];
    }
    [youtube loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.youtube.com/embed/", business.videoId]]]];
    [youtube setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame;
        frame = youtube.frame;
        frame.origin.y = 40;
        youtube.frame = frame;
    } completion:^(BOOL finished){
        CGRect corner = youtube.frame;
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(corner.origin.x-5,corner.origin.y -5, 25, 25)];
        closeButton.backgroundColor = [UIColor clearColor];
        [closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeVideoView:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeButton];
    }];
}

-(void)setBusinessData:(Business *)inBusiness
{
    self.business = inBusiness;
    coupons = [[NSArray alloc] initWithArray:[inBusiness coupons]];
    NSLog(@"# of coupons: %d",[coupons count]);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    //[headerView setBackgroundColor:[[UIColor alloc] initWithRed:0.05 green:0.2 blue:0.3 alpha:1.0]];
    /*[headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);;
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];*/

    return headerView;
}


- (NSString *)getNameFromSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Coupons for %@",business.name];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Coupons for %@",business.name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView 
numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Number of rows: %d",[coupons count]);
    return [coupons count];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
 */

- (UITableViewCell *)tableView:(UITableView *)tableView 
cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:self options:NULL];
        cell = (CouponTableViewCell *) [nib objectAtIndex:0];
    }
   //cell.backgroundColor=[UIColor clearColor];
    Coupon *coupon = [coupons objectAtIndex:indexPath.row]; 

    ((CouponTableViewCell*) cell).titleLabel.text = coupon.title;
    ((CouponTableViewCell*) cell).subTitleLabel.text = coupon.description;
    cell.contentView.backgroundColor = [UIColor clearColor];

    return cell;

}

- (void)showOptions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    //actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    NSArray *optionsArray = [[NSArray alloc] initWithObjects:
                             @"SMS",
                             @"EMail",
                             @"Twitter",
                             @"Facebook",
                             @"Google+",
                             @"Pinterest",
                             nil];
    // This code may prove to be more generic for future projects.  Perhaps consider this.
    // In fact, I think we should create these options based on what exists in the Location entry
    // There may be no website, for example
    
    int idx = 0;
    for (NSString *option in optionsArray) {
        [actionSheet addButtonWithTitle:option];
        idx++;
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    actionSheet.cancelButtonIndex = idx++;    
    [actionSheet showInView:self.view];
    //[actionSheet release];
}

-(void)closeVideoView:(id)sender
{
    [closeButton removeFromSuperview];
    [closeButton release];
    NSLog(@"Closing a VIDEO view");
    [UIView animateWithDuration:0.5 animations:^{
        overlay.alpha = 0.0;
        CGRect frame;
        frame = youtube.frame;
        frame.origin.y = 460;
        youtube.frame = frame;
    } completion:^(BOOL finished){
        [youtube removeFromSuperview];
        [youtube release];
        youtube = nil;
    }];

}

-(void)closeView:(id)sender
{
    [closeButton removeFromSuperview];
    [closeButton release];
    NSLog(@"Closing a COUPON view");
    [UIView animateWithDuration:0.5 animations:^{
        overlay.alpha = 0.0;
        CGRect frame;
        frame = couponView.frame;
        frame.origin.y = 460;
        couponView.frame = frame;
    } completion:^(BOOL finished){
        [couponView removeFromSuperview];
        [couponView release];
    }];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    overlay = [[UIView alloc] initWithFrame:self.view.window.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.0;
    [self.view addSubview:overlay];
    Coupon *coupon = [coupons objectAtIndex:indexPath.row];
    if (![coupon.imageName isEqualToString:@""] && coupon.imageName){
        CouponImageView *tmpView = [[CouponImageView alloc] initWithCoupon:coupon];
        [tmpView setBusinessName:business.name];
        couponView = tmpView;
    }else{
        CouponView *tmpView = [[CouponView alloc] initWithCoupon:coupon];
        [tmpView setBusinessName:business.name];
        couponView = tmpView;
    }
    [self.view addSubview:couponView];
    [UIView animateWithDuration:0.5 animations:^{
        overlay.alpha = 0.7;
        CGRect frame;
        frame = couponView.frame;
        frame.origin.y = 40;
        couponView.frame = frame;
    } completion:^(BOOL finished){
    CGRect corner = couponView.frame;
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(corner.origin.x-5,corner.origin.y -5, 25, 25)];
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}


@end
