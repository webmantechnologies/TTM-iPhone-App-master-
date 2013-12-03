//
//  BusinessViewController.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "Coupon.h"
#import "CouponView.h"

@interface BusinessViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>
{
    //IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *businessView;
    IBOutlet UIImageView *image;
    IBOutlet UIButton *videoBtn;
    IBOutlet UIButton *mapBtn;
    IBOutlet UILabel *name;
    IBOutlet UILabel *address;
    IBOutlet UIButton *phone;
    IBOutlet UIButton *website;
    IBOutlet UILabel *description;
    UIImageView *descriptionView;
    Business *business;
    Location *closest;
    UIBarButtonItem *optionsButton;
    UITableView *couponsTable;
    NSArray *coupons;
    UIView *couponView;
    UIView *overlay;
    UIButton *closeButton;
    UIWebView *youtube;
}

//@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *businessView;
@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) UIButton *videoBtn, *mapBtn;
@property (nonatomic, retain) IBOutlet UILabel *name, *address, *description;
@property (nonatomic, retain) UIButton *phone, *website, *closeButton;
@property (nonatomic, retain) Business *business;
@property (nonatomic, retain) UIBarButtonItem *optionsButton;
@property (nonatomic, retain) UITableView *couponsTable;
@property (nonatomic, retain) NSArray *coupons;
@property (nonatomic, retain) UIImageView *descriptionView;
@property (nonatomic, retain) UIView *couponView;
@property (nonatomic, retain) UIView *overlay;
@property (nonatomic, retain) UIWebView *youtube;

-(void)setBusinessData:(Business *)inBusiness;
-(void)makeCall;
-(void)showWebsite;
-(NSString *)formatPhone:(NSString *)phoneNum;

@end
