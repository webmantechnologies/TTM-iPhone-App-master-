//
//  CouponView.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "TTMAppDelegate.h"
//#import "GooglePlusShare.h"

#import "Coupon.h"

@interface CouponView : UIView <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBLoginViewDelegate,UIAlertViewDelegate>
{
    Coupon *coupon;
    FBLoginView *loginview;
    UILabel *title;
    UILabel *description;
    UILabel *expirationDate;
    NSString *businessName;
    id<FBGraphUser> loggedInUser;
    //GooglePlusShare *googlePlus;
}

@property (nonatomic, retain) UILabel *title, *description, *expirationDate;
@property (nonatomic, retain) Coupon *coupon;
@property (nonatomic, retain) FBLoginView *loginview;
@property (nonatomic, retain) NSString *businessName;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

-(id)initWithCoupon:(Coupon *)inCoupon;
//-(void)showAlert:(NSString *)message;
- (void)postStatusUpdate;
- (void)postPhoto;

@end
