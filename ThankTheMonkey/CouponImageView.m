//
//  CouponImageView.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponImageView.h"
#import "SocialMediaButtons.h"
#import "TTMHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation CouponImageView

@synthesize couponImage, coupon, loginview, businessName;

static NSString * const kClientId = @"989775631679.apps.googleusercontent.com";

- (id)initWithCoupon:(Coupon *)inCoupon//WithFrame:(CGRect)frame
{
    coupon = inCoupon;
    self = [super initWithFrame:CGRectMake(8, 460, 304, 0)];
    if (self) {
        fbToggle = FALSE;
        // Initialization code
        //couponImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 460, 304, 193)];
        couponImage = [[UIImageView alloc] initWithImage:[TTMHelper getImageFromName:coupon.imageName]];
        couponImage.contentMode = UIViewContentModeScaleAspectFit;
        CGRect frame = couponImage.frame;
        frame.size.width = 304;
        frame.size.height = (304/couponImage.image.size.width)*couponImage.image.size.height;
        couponImage.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = TRUE;
        CGRect viewframe = couponImage.frame;
        viewframe.size.width = 304;
        viewframe.size.height = frame.size.height + 60;
        viewframe.origin.y = 460;
        viewframe.origin.x = 8;
        self.frame = viewframe;
        
        UILabel *sMediaLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, couponImage.frame.size.height, 142, 18)];
        sMediaLabel.backgroundColor = [UIColor clearColor];
        sMediaLabel.font = [UIFont systemFontOfSize:10];
        [sMediaLabel setText:@"Share this deal with friends!"];
        
        SocialMediaButtons *shareButtons = [[SocialMediaButtons alloc] initWithFrame:CGRectMake(0, couponImage.frame.size.height + 14, 304, 42)];
        [self addSubview:couponImage];
        [self addSubview:shareButtons];
        [self addSubview:sMediaLabel];
        
        NSLog(@"Haven't created loginview.  Currently logged %@",(fbLoggedIn ? @"IN" : @"OUT"));
        if (!fbLoggedIn){
            loginview = [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
            
            loginview.frame = CGRectOffset(loginview.frame, 47, 142);
            
            loginview.delegate = self;
            
            [self addSubview:loginview];
            [self sendSubviewToBack:loginview];
            [loginview sizeToFit];
        }
        
    }
    return self;
}

-(void)emailCoupon
{
    NSLog(@"Showing mailer");
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    
    [mailer setSubject:@"Coupon from Thank the Monkey!"];
    
    //NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
    //[mailer setToRecipients:toRecipients];
    
    NSData *imageData = UIImagePNGRepresentation(couponImage.image);
    [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"coupon"];
    
    NSString *emailBody = [NSString stringWithFormat:@"A great deal at:\n\n%@\n\nThank The Monkey!\n\n(http://thankthemonkey.com/qrcode/)",businessName];
    [mailer setMessageBody:emailBody isHTML:NO];
    
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentModalViewController:mailer animated:YES];
    
    [mailer release];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            [self showAlert:@"Email" result:nil error:error];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [controller dismissModalViewControllerAnimated:YES];
}


-(void)smsCoupon
{
    MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
    sms.messageComposeDelegate = self;
    
    [sms setBody:[NSString stringWithFormat:@"%@@%@--Thank The Monkey!\n\n(http://thankthemonkey.com/qrcode/)",coupon.title,businessName,coupon.description]];
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentModalViewController:sms animated:YES];
    
    [sms release];
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"SMS cancelled.");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message sent.");
            [self showAlert:@"Text Message" result:nil error:nil];
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed.");
        default:
            break;
    }
    [controller dismissModalViewControllerAnimated:YES];
}

-(void)tweetCoupon
{
    // Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    // Optional: set an image, url and initial text
    [twitter addImage:couponImage.image];
    
    NSString *initialText = [NSString stringWithFormat:@"%@ at %@ from Thank The Monkey",coupon.title, businessName];
    [twitter setInitialText:initialText];
    
    // Show the controller
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Tweet Status";
        NSString *msg; 
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"Tweet compostion was canceled.";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Tweet composition completed.";
        
        // Show alert to see how things went...
        [self showAlert:@"Twitter" result:nil error:nil];
        
        // Dismiss the controller
        TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
        [del.navController dismissModalViewControllerAnimated:YES];
    };
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self postPhoto];
    }
}

-(void)facebookCoupon
{
    if (fbLoggedIn) {
        UIAlertView *confirmPost = [[UIAlertView alloc] initWithTitle:@"Share with Friends?" message:@"Would you like to share this coupon on Facebook?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Yes!", nil];
        [confirmPost show];
        //[self postPhoto];
    }else{
        if (!fbToggle){
            fbToggle = TRUE;
            
            loginview =
            [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
            
            loginview.frame = CGRectOffset(loginview.frame, 47, 142);
            loginview.delegate = self;
            
            [self addSubview:loginview];
                        
            
            [loginview sizeToFit];
            
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame;
                frame = loginview.frame;
                frame.origin.y = frame.origin.y + 49;
                loginview.frame = frame;
            } completion:^(BOOL finished){
            }];
        }else{
            fbToggle = FALSE;
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame;
                frame = loginview.frame;
                frame.origin.y = frame.origin.y - 49;
                loginview.frame = frame;
            } completion:^(BOOL finished){
            }];
        }
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    NSLog(@"LOGGED IN to Facebook!");
    fbLoggedIn = TRUE;
    [loginView setHidden:TRUE];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    fbLoggedIn = FALSE;
    NSLog(@"Logged OUT of Facebook!");
    [loginView setHidden:FALSE];
    /*
    if (fbToggle){
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame;
            frame = loginview.frame;
            frame.origin.y = frame.origin.y - 49;
            loginview.frame = frame;
        } completion:^(BOOL finished){
        }];
    }*/
}

// Post Photo button handler
- (void)postPhoto {
    NSLog(@"Coupon image name: %@",coupon.imageName);
    NSMutableDictionary* postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"http://thankthemonkey.com/qrcode/", @"link",
                                       [TTMHelper getURLForImage:coupon.imageName], @"picture",
                                       coupon.title,@"name",
                                       //coupon.title, @"name",
                                       //coupon.description, @"caption",
                                       businessName,@"caption",
                                       coupon.description,@"description",
                                       @"A great deal from Thank The Monkey!",  @"message",
                                       nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         [self showAlert:@"Facebook" result:result error:error];
         // Show the result in an alert
     }];
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        //NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully shared via %@!",message];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)googlePlusCoupon
{
    NSLog(@"Hello there");
//    googlePlus = [[[GooglePlusShare alloc] initWithClientID:kClientId]autorelease];
//    googlePlus.delegate=self;
//    [[[[googlePlus shareDialog]setURLToShare:[NSURL fileURLWithPath:[NSString stringWithFormat:@"http://ttm.yourmobicity.com/proba2/%@",coupon.imageName] isDirectory:false]] setPrefillText:[NSString stringWithFormat:@"%@: %@ at %@",coupon.title,coupon.description,businessName]] open];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
