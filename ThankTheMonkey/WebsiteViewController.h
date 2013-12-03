//
//  WebsiteViewController.h
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsiteViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    NSString *url;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *url;

-(void)showWebsite;

@end
