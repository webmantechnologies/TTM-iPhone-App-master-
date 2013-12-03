//
//  TTMListViewController.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <coreLocation/CoreLocation.h>

@interface TTMListViewController : UITableViewController
{
    NSArray *locations,*businesses;
    NSMutableDictionary *images;
}

@property (nonatomic, retain) NSArray *locations,*businesses;
@property (nonatomic, retain) NSMutableDictionary *images;

-(void) setData:(NSArray *)data;

@end
