//
//  TTMLoadingViewController.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMLoadingViewController.h"

@interface TTMLoadingViewController ()

@end

@implementation TTMLoadingViewController

@synthesize progressView;
@synthesize database;
@synthesize currentLocation;
@synthesize currentLatLon;
@synthesize currentMarket;
@synthesize catViewController;
@synthesize navController;
@synthesize flipButton, searchButton;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    progressView = [[ProgressView alloc] initWithFrame:CGRectMake(0, 416-48, 320, 48)];
    [progressView.progressLabel setText:@"Updating database..."];
    [progressView setHidden:TRUE];
    [self.view addSubview:progressView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
