//
//  TTMCategoryViewController.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMCategoryViewController.h"
#import "TTMMainViewController.h"
#import "TTMAppDelegate.h"
#import "TTMHelper.h"
#import "MediaPartnerTableViewCell.h"
#import "CategoryTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WebsiteViewController.h"
#import "Business.h"
#import "BusinessTableData.h"
#import "BusinessViewController.h"
#import "Coupon.h"

@interface TTMCategoryViewController ()

@end

@implementation TTMCategoryViewController

@synthesize categories,businesses,tableView,flipButton, bottomBar;
@synthesize mySearchBar, searchController, searchResults,searchables;
@synthesize mainMapView,businessesArray,locations;

/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float == 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    displayingPrimary = TRUE;
    self.view.backgroundColor = [UIColor clearColor];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monkey_banner.png"]];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    titleImage.frame = CGRectMake(0, 0, 180, 44);
    [titleView addSubview:titleImage];
    //[titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 375) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //tableView.layer.cornerRadius = 8.0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tag = 100;
    [self.view addSubview:tableView];
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
    [self.navigationController.toolbar setHidden:NO];
    
    
    // Set up search bar and controller
    searchables = [[NSMutableArray alloc] init];
    [self findSearchables];
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    mySearchBar.delegate = self;
    mySearchBar.hidden = FALSE;
    //[self.view addSubview:mySearchBar];
    searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:mySearchBar contentsController:self];
    
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.searchResultsTableView.tag = 101;
    
    NSLog(@"Setting searchButton Action to 'showSearch:'");
    [del.searchButton setTarget:self];
    [del.searchButton setAction:@selector(showSearch:)];
    //self.title = @"Thank the Monkey";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"firstTime.txt"];
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:filePath ] == YES){
        NSLog (@"Firsttime file exists");
    }else{
        NSLog (@"First Time File not found");
        //Write to file
        NSError *error;
        // File we want to create/edit in the documents directory 
        NSString *filePath = [documentsDirectory 
                              stringByAppendingPathComponent:@"firstTime.txt"];
        
        // String to write
        NSString *str = @"";
        
        // Write the file
        [str writeToFile:filePath atomically:YES 
                encoding:NSUTF8StringEncoding error:&error];
        UIAlertView *firstTimeNotice = [[UIAlertView alloc] initWithTitle:@"Welcome to\nThank the Monkey!" message:@"Find coupons and great deals at businesses near to you.  Present the app coupons at your favorite places for big savings and share them with friends!" delegate:self cancelButtonTitle:@"Thanks!" otherButtonTitles:nil];
        [firstTimeNotice show];
        [firstTimeNotice release];
    }
    
    MKCoordinateRegion region;
    //NSLog(@"Current lat/lon: %f, %f", location.latitude, location.longitude);
    region.center.latitude = del.currentLatLon.latitude;
    region.center.longitude = del.currentLatLon.longitude;
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    [mainMapView setRegion:region];
    
    mainMapView.hidden = TRUE;
    
    [self.view addSubview:mainMapView];
    //[mainMapView addSubview:mySearchBar];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"I'm appearing!!  Yay!!");
    [self.navigationController setToolbarHidden:FALSE animated:YES];  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) flipMap
{
    [flipButton setTitle:(displayingPrimary ? @"List" : @"Map")];
    mainMapView.hidden = (displayingPrimary ? FALSE : TRUE);
    //NSLog(@"# locations: %d",[locations count]);
    //NSLog(@"# annotations: %d", [mainMapView.annotations count]);
    if(displayingPrimary)
        self.navigationController.topViewController.navigationItem.leftBarButtonItem.enabled=FALSE;
    else
        self.navigationController.topViewController.navigationItem.leftBarButtonItem.enabled=TRUE;
    
    [UIView transitionFromView:(displayingPrimary ? tableView : mainMapView)
                        toView:(displayingPrimary ? mainMapView : tableView)
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

-(void)setCategories:(NSArray *)dataArray withBusinesses:(OrderedDictionary *)businesses
{
    //categories = [[NSArray alloc] initWithArray:dataArray];
    categories=[[NSMutableDictionary alloc]init];
    for (BusinessType *obj in dataArray)
    {
        [categories setObject:obj forKey:obj.name];
    }
    self.businesses = businesses;
    [self.tableView reloadData];
    mainMapView = [[TTMMapView alloc] init];
    locations = [[NSMutableArray alloc] init];
    businessesArray = [[NSMutableArray alloc] init];
    for (id key in businesses){
        if (![key isEqualToString:@"MediaPartner"]){
            [businessesArray addObjectsFromArray:[businesses objectForKey:key]];
        }
    }
    [mainMapView setData:businessesArray];
}


/**
 This is the delegate of the alert, it is used if you select ok the system go to google maps, and if you select cancel the systen didn¬¥t do anything
 */
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
}


#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText 
                             scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.description contains[cd] %@)",searchText,
                                    searchText];
    
    self.searchResults = [self.searchables filteredArrayUsingPredicate:resultPredicate];
}

-(void)findSearchables
{
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [searchables addObjectsFromArray:[Business getAllInMarket:del.currentMarket.primaryKey withCoupons:TRUE]];
    //[searchables addObjectsFromArray:[Coupon findAll]];
    NSLog(@"Searchables count: %d",[searchables count]);
}

- (void)showSearch:(id)selector
{
    NSLog(@"tapped search button");
    [tableView setTableHeaderView:mySearchBar];
    mySearchBar.hidden = FALSE;
    [mySearchBar becomeFirstResponder];
    [searchController setActive:TRUE animated:TRUE];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    tableView.tableHeaderView=nil;
    mySearchBar.hidden = TRUE;
    [mySearchBar resignFirstResponder];
    mySearchBar.text = @"";
    [searchController setActive:FALSE animated:TRUE];
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
    if (tableView.tag == 100){
        return [businesses count];
    }else{
        return [searchResults count];
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100){
        return ((indexPath.row == 0) ? 60 : 50);
    }else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100){
        static NSString *CellIdentifier = @"Cell";
        static NSString *CellIdentifier2 = @"MPCell";
        
        NSString *categoryName = [businesses keyAtIndex:indexPath.row];
        //NSLog(@"CAT NAME: %@",categoryName);
        if ([categoryName isEqualToString:@"MediaPartner"]){
            MediaPartner *mp = [businesses objectForKey:categoryName];
           // NSLog(@"Hey, I'm a Media Partner! My logo is named %@",mp.bannerName);
            MediaPartnerTableViewCell *cell = (MediaPartnerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            if (cell == nil) {
                cell = [[MediaPartnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            }
            [cell setMpImage:[TTMHelper getImageFromName:mp.bannerName]];
            return cell;
        }else{
            NSArray *catBusinesses = [businesses objectForKey:categoryName];
            CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            BusinessType *currentCat=[categories objectForKey:categoryName];
            NSLog(@"Categories count: %d",[categories count]);
            //for (BusinessType *c in categories){
            //    if ([c.name isEqualToString:categoryName]){
             //       NSLog(@"NAME: %@",c.imageName);
            //        currentCat = c;
            //    }
            //}
            
            // Configure the cell...
            //NSString *query = [NSString stringWithFormat:@"SELECT * From BusinessType where name = '%@'",categoryName];
            //NSLog(@"QUERY: %@",query);
            //BusinessType *bt = [[BusinessType findWithSql:query] objectAtIndex:0];
            //NSLog(@"category image name: %@",currentCat.imageName);
            cell.cellLabel.text = [NSString stringWithFormat:@"%@", categoryName];
            cell.countLabel.text = [NSString stringWithFormat:@"(%d)",[catBusinesses count]];
            [cell setCategoryIconImage:[TTMHelper getImageFromName:currentCat.imageName]];
            return cell;
        }

    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
          // cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] name];
        return cell;
    }
    //return [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"tableView%d:cellForRowAtIndexPath:", tableView.tag])];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100){
         [self.view setAlpha:0.0f];
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        if (indexPath.row == 0){
            MediaPartner *mp = [businesses objectForKey:@"MediaPartner"];
            WebsiteViewController *siteViewController = [[WebsiteViewController alloc] init];
            siteViewController.title = mp.name;
            siteViewController.url = mp.website;
            [siteViewController showWebsite];
             [self.view setAlpha:0.0f];
            [self.navigationController pushViewController:siteViewController animated:TRUE];
        }else {
            
            TTMMainViewController *tmv = [[TTMMainViewController alloc] init];
            NSMutableArray *tvData = [[NSMutableArray alloc] initWithObjects:[businesses objectForKey:@"MediaPartner"], nil];
            NSArray *catBusinesses = [businesses objectForKey:[businesses keyAtIndex:indexPath.row]];
            NSMutableArray *catBusinessesSorted = [[NSMutableArray alloc] init];
            
            TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
            CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:del.currentLatLon.latitude longitude:del.currentLatLon.longitude];
            //NSLog(@"CURRENT LOCATION!  %f, %f",currentLoc.coordinate.latitude, currentLoc.coordinate.longitude);
            //NSLog(@"Whats this bidness?  Why ID %d",business.primaryKey);
            for (Business *b in catBusinesses){
                BusinessTableData *btd = [[BusinessTableData alloc] initWithBusiness:b];
                Location *closest = [b closestFromLocation:currentLoc];
                //NSLog(@"CLOSEST LOCATION?  %d",[closest.businessId intValue]);
                CLLocation *closestLoc = [closest geoLocation];
                 [self.view setAlpha:0.0f];
                btd.distance = [NSNumber numberWithDouble:[currentLoc distanceFromLocation:closestLoc]*0.00062137119];
                [catBusinessesSorted addObject:btd];
                [btd release];
            }
            
            NSArray *finalBusinesses = [catBusinessesSorted sortedArrayUsingComparator:^(BusinessTableData *obj1, BusinessTableData *obj2) {
                if ([obj1.distance floatValue] < [obj2.distance floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                
                if ([obj1.distance floatValue] > [obj2.distance floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            for (BusinessTableData *btd in finalBusinesses){
                [tvData addObject:btd];
            }
            //[tvData addObjectsFromArray:finalBusinesses];
            [tmv setTitle:[businesses keyAtIndex:indexPath.row]];
            [tmv setData:tvData];
             [self.view setAlpha:0.0f];
            [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
            [self.navigationController pushViewController:tmv animated:TRUE];
        }

    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
        BusinessViewController *businessViewController = [[BusinessViewController alloc] init];
        //look for the restaurant
      /*  NSInteger inditex = 0;
        bool foundBusiness=false;
        for (inditex=0;foundBusiness==false;inditex++)
        {
            Business *b=[searchResults objectAtIndex:inditex];
            if ([b name]==[[searchResults objectAtIndex:indexPath.row]name])
            {
                foundBusiness=true;
            }
        }*/
        //look for the restaurant
        [businessViewController setBusinessData:[searchResults objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:businessViewController animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated
{     [super viewWillAppear:animated];
    [self.view setAlpha:1.0f];
    
    
}

@end
