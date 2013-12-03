//
//  TTMCategoryViewController.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessType.h"
#import "OrderedDictionary.h"
#import "TTMMapView.h"

@interface TTMCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate, UISearchDisplayDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *categories;
    OrderedDictionary *businesses;
    UITableView *tableView;
    UIBarButtonItem *flipButton;
    UIToolbar *bottomBar;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchController;
    NSArray *searchResults;
    NSMutableArray *searchables,*locations,*businessesArray;
    TTMMapView *mainMapView;
    BOOL displayingPrimary;
}

@property (nonatomic, retain) NSMutableDictionary *categories;
@property (nonatomic, retain) OrderedDictionary *businesses;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIBarButtonItem *flipButton;
@property (nonatomic, retain) UIToolbar *bottomBar;
@property (nonatomic, retain) UISearchBar *mySearchBar;
@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) NSMutableArray *searchables,*locations,*businessesArray;
@property (nonatomic, retain) TTMMapView *mainMapView;

-(void)setCategories:(NSArray *)dataArray withBusinesses:(OrderedDictionary*)businesses;
-(void)findSearchables;

@end
