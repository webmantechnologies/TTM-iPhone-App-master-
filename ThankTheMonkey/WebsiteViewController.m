//
//  WebsiteViewController.m
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebsiteViewController.h"
#import "TTMTitleView.h"

@implementation WebsiteViewController

@synthesize webView,url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float == 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view from its nib.
    TTMTitleView *titleView = [[TTMTitleView alloc] init];
    self.navigationItem.titleView = titleView;
    webView.delegate = self;
	//self.title = @"Website";
    webView.scalesPageToFit = YES;
	UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
	[[self navigationItem] setRightBarButtonItem:reloadButton];
	//[reloadButton release];

}
- (void)goBack:(id) sender {
    [webView goBack];
}

-(void) viewDidAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden = FALSE;
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
	[tmpimg removeFromSuperview];
}

- (void) viewDidDisappear:(BOOL)animated {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
	[tmpimg removeFromSuperview];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
	[tmpimg removeFromSuperview];
}
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
	//NSLog(@"web starts");
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)showWebsite
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];// autorelease];
    av.frame=CGRectMake(145, 230, 25, 25);
    av.tag  = 1;
    [self.view addSubview:av];
    [av startAnimating];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
