//
//  CouponImageView.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "TTMAppDelegate.h"
//#import "GooglePlusShare.h"
#import "Coupon.h"

@interface CouponImageView : UIView <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,FBLoginViewDelegate,UIAlertViewDelegate>
{
    UIImageView *couponImage;
    Coupon *coupon;
    FBLoginView *loginview;
    UILabel *expirationDate;
    NSString *businessName;
    BOOL fbToggle;
    BOOL fbLoggedIn;
    //GooglePlusShare *googlePlus;
}

@property (nonatomic, retain) UIImageView *couponImage;
@property (nonatomic, retain) Coupon *coupon;
@property (nonatomic, retain) FBLoginView *loginview;
@property (nonatomic, retain) NSString *businessName;

-(id)initWithCoupon:(Coupon *)inCoupon;
-(void)postPhoto;
-(void)showAlert:(NSString *)message;

@end
