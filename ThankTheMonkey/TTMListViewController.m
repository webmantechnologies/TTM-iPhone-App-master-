//
//  TTMListViewController.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMListViewController.h"
#import "TTMAppDelegate.h"
#import "Location.h"
#import "Business.h"
#import "BusinessTableViewCell.h"

@interface TTMListViewController ()

@end

@implementation TTMListViewController

@synthesize locations, businesses, images;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //UIImageView *topImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wkkx_banner.png"]];
    //topImage.frame = CGRectMake(0, 0, 320, 55);
    //[self.tableView setTableHeaderView:topImage];
}

-(void) setData:(NSArray *)data
{
    businesses = data;
    [self.tableView reloadData];
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		//Load custom cell from NIB file
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BusinessTableViewCell" owner:self options:NULL];
        cell = (BusinessTableViewCell *) [nib objectAtIndex:0];
	}
       cell.backgroundColor=[UIColor clearColor];
    Business *business = [businesses objectAtIndex:indexPath.row];
    
	//cell.textLabel.font = [UIFont boldSystemFontOfSize:14];// systemFontOfSize:16];
	//cell.textLabel.textColor = [[UIColor alloc] initWithRed:0.25 green:0.4 blue:0.5 alpha:1.0];
    //[[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
    /*
	cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines=2;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
     */
    ((BusinessTableViewCell*)
     cell).titleLabel.text = [NSString stringWithFormat:@"%@\n",business.name];
    NSString *numCoupons = [NSString stringWithFormat:@"(%d coupons)",[[business coupons] count]];
    ((BusinessTableViewCell*)
     cell).subTitleLabel.text = numCoupons;
    
    
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude:del.currentLatLon.latitude longitude:del.currentLatLon.longitude];
    
    Location *closest = [business closestFromLocation:currentLoc];
    CLLocation *closestLoc = [closest geoLocation];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.roundingIncrement = [NSNumber numberWithDouble:0.01];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *numberDistance = [NSNumber numberWithDouble:[currentLoc distanceFromLocation:closestLoc]*0.00062137119];
    NSString *distance = [NSString stringWithFormat:@"(%@mi)",[formatter stringFromNumber:numberDistance]];
     
    ((BusinessTableViewCell*)
     cell).infoLabel.text = distance;
     
    ((BusinessTableViewCell*)
     cell).imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (![business.imageName isEqualToString:@""] && !(business.imageName == NULL)){
        NSRange match;
        
        match = [business.imageName rangeOfString: @"/"];
        NSString *imageName;
        if (match.location == NSNotFound)
            imageName = business.imageName;
        else
            imageName = [business.imageName substringFromIndex:match.location + 1];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            UIImage *image = [self.images objectForKey:imageName];
            
            if(!image)
            {
                // Image is not on the cached NSMUtableDictionary. Check if image is available on the documents folder and copy from there
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                
                NSString *documentsFolder = [paths objectAtIndex:0];
                //NSLog(@"Documents folder is %@", documentsFolder);
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsFolder stringByAppendingPathComponent:imageName]]) {
                    UIImage *unresizedImage = [UIImage imageWithContentsOfFile: [documentsFolder stringByAppendingPathComponent:imageName]];     
                    image = unresizedImage;//[self resizeImage:unresizedImage imageWidth:75 imageHeight:75];
                    [self.images setValue:image forKey:imageName];            
                }
                
                // NSFileManager *the_pFileManager = [NSFileManager defaultManager];
                // NSLog(@" Full path of file to be created %@", [documentsFolder stringByAppendingPathComponent:the_pArtist.image]);
                else {
                    NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:business.imageName]]];
                    UIImage *unresizedImage = [[UIImage alloc] initWithData:receivedData];
                    image = unresizedImage;//[self resizeImage:unresizedImage imageWidth:75 imageHeight:75];
                    [self.images setValue:image forKey:imageName];
                    NSData *pngFile = UIImagePNGRepresentation(unresizedImage);
                    NSLog(@"Business image is %@", imageName);
                    
                    //NSLog(@"to be copied to %@", documentsFolder);
                    [pngFile writeToFile:[documentsFolder stringByAppendingPathComponent:imageName] atomically:YES];
                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[cell imageView] setImage:image];
                [cell setNeedsLayout];
            });
        });
    }
    return cell;

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
