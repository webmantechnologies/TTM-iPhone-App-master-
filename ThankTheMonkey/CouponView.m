//
//  CouponView.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponView.h"
#import "SocialMediaButtons.h"
#import "TTMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#import <FacebookSDK/FacebookSDK.h>


@implementation CouponView

@synthesize title, description, expirationDate, coupon, loginview, businessName;
@synthesize loggedInUser;

BOOL fbToggle = FALSE;
BOOL fbLoggedIn = FALSE;

static NSString * const kClientId = @"989775631679.apps.googleusercontent.com";


-(id)initWithCoupon:(Coupon *)inCoupon
{
    
    
    coupon = inCoupon;
    UIImageView *top = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_top_white.png"]];
    top.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = CGRectMake(0, 0, 304, 60);
    top.frame = frame;
    title = [[UILabel alloc] initWithFrame:frame];
    title.font = [UIFont systemFontOfSize:24];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    [title setTextColor:[UIColor blackColor]];
    title.adjustsFontSizeToFitWidth = TRUE;
    title.text = coupon.title;
    
    UIImageView *middle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_middle_white.png"]];
    middle.contentMode = UIViewContentModeScaleAspectFit;
    frame = CGRectMake(0, 59, 304, 73);
    middle.frame = frame;
    description = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, 292, 73)];
    description.font = [UIFont systemFontOfSize:14];
    description.backgroundColor = [UIColor clearColor];
    [description setTextColor:[UIColor blackColor]];
    description.numberOfLines = 0;
    description.text = coupon.description;
    [description sizeToFit];
    frame = description.frame;
    frame.origin.x = 8;
    frame.origin.y = 59;
    description.frame = frame;
    
    UIImageView *bottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon_bottom_white.png"]];
    bottom.contentMode = UIViewContentModeScaleAspectFit;
    frame = CGRectMake(0, 131, 304,60);
    bottom.frame = frame;
    
    UILabel *sMediaLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 125, 142, 18)];
    sMediaLabel.font = [UIFont systemFontOfSize:10];
    [sMediaLabel setText:@"Share this deal with friends!"];
    
    /*
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 142, 42, 42)];
    emailButton.backgroundColor = [UIColor clearColor];
    [emailButton setImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
    
    UIButton *smsButton = [[UIButton alloc] initWithFrame:CGRectMake(47, 142, 42, 42)];
    smsButton.backgroundColor = [UIColor clearColor];
    [smsButton setImage:[UIImage imageNamed:@"sms_icon.png"] forState:UIControlStateNormal];
    
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 142, 42, 42)];
    fbButton.backgroundColor = [UIColor clearColor];
    [fbButton setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    
    UIButton *twButton = [[UIButton alloc] initWithFrame:CGRectMake(132, 142, 42, 42)];
    twButton.backgroundColor = [UIColor clearColor];
    [twButton setImage:[UIImage imageNamed:@"twitter_icon.png"] forState:UIControlStateNormal];
    
    UIButton *gpButton = [[UIButton alloc] initWithFrame:CGRectMake(174, 142, 42, 42)];
    gpButton.backgroundColor = [UIColor clearColor];
    [gpButton setImage:[UIImage imageNamed:@"google_plus_icon.png"] forState:UIControlStateNormal];
    
    UIButton *fsButton = [[UIButton alloc] initWithFrame:CGRectMake(216, 142, 42, 42)];
    fsButton.backgroundColor = [UIColor clearColor];
    [fsButton setImage:[UIImage imageNamed:@"foursquare_icon.png"] forState:UIControlStateNormal];
    
    UIButton *igButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 142, 42, 42)];
    igButton.backgroundColor = [UIColor clearColor];
    [igButton setImage:[UIImage imageNamed:@"instagram_icon.png"] forState:UIControlStateNormal];
     */

    SocialMediaButtons *shareButtons = [[SocialMediaButtons alloc] initWithFrame:CGRectMake(0, 142, 304, 42)];
    
    self = [super initWithFrame:CGRectMake(8, 460, 304, 193 + 48)];
    self.layer.cornerRadius = 8;
    self.clipsToBounds = TRUE;
    [self addSubview:top];
    [self addSubview:middle];
    [self addSubview:bottom];
    [self addSubview:sMediaLabel];
    [self addSubview:shareButtons];
    /*
    [self addSubview:emailButton];
    [self addSubview:smsButton];
    [self addSubview:fbButton];
    [self addSubview:twButton];
    [self addSubview:gpButton];
    [self addSubview:fsButton];
    [self addSubview:igButton];
     */
    [self addSubview:title];
    [self addSubview:description];
    NSLog(@"Haven't created loginview.  Currently logged %@",(fbLoggedIn ? @"IN" : @"OUT"));
    if (!fbLoggedIn){
        loginview = [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"publish_actions"]];
    
        loginview.frame = CGRectOffset(loginview.frame, 47, 142);
            
        loginview.delegate = self;
    
        [self addSubview:loginview];
        [self sendSubviewToBack:loginview];
        [loginview sizeToFit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
    //NSData *imageData = UIImagePNGRepresentation(photo);
    //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"issuePhoto"];
    
    NSString *emailBody = [NSString stringWithFormat:@"%@ at %@\n\n%@\n\nThank The Monkey!\n\n(http://thankthemonkey.com/qrcode/)",coupon.title,businessName,coupon.description];
    [mailer setMessageBody:emailBody isHTML:NO];
    
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentViewController:mailer animated:YES completion:nil];
    
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
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)smsCoupon
{
    MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];
    sms.messageComposeDelegate = self;
    
    [sms setBody:[NSString stringWithFormat:@"%@%@%@ Thank The Monkey!\n\n(http://thankthemonkey.com/qrcode/)",coupon.title,businessName,coupon.description]];
    
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentViewController:sms animated:YES completion:nil];
    
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
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)tweetCoupon
{
    // Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    // Optional: set an image, url and initial text
    
    NSString *initialText = [NSString stringWithFormat:@"%@ at %@ from Thank The Monkey",coupon.title, businessName];
    [twitter setInitialText:initialText];
    
    // Show the controller
    TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
    [del.navController presentViewController:twitter animated:YES completion:nil];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *titlee = @"Tweet Status";
        NSString *msg; 
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"Tweet compostion was canceled.";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Successfully shared via Tweeter";
        
        // Show alert to see how things went...
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:titlee message:msg delegate:description cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        
        //[self showAlert:@"Twitter" result:msg error:TWTweetComposeViewControllerResultCancelled];
        // Dismiss the controller
        TTMAppDelegate *del = (TTMAppDelegate *)[UIApplication sharedApplication].delegate;
        [del.navController dismissViewControllerAnimated:YES completion:nil];
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
            
            
            [self sendSubviewToBack:loginview];
            
             
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
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    fbLoggedIn = FALSE;
    NSLog(@"Logged OUT of Facebook!");
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

// Post Status Update button handler
- (void)postStatusUpdate {
    
    // Post a status update to the user's feed via the Graph API, and display an alert view 
    // with the results or an error.
    
    NSString *message = [NSString stringWithFormat:@"Updating %@'s status at %@", 
                         self.loggedInUser.first_name, [NSDate date]];
    
    [FBRequestConnection startForPostStatusUpdate:message
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    
                                    [self showAlert:message result:result error:error];
                                    //self.buttonPostStatus.enabled = YES;
                                }];
    
    //self.buttonPostStatus.enabled = NO;       
}

// Post Photo button handler
- (void)postPhoto {

        NSMutableDictionary* postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"http://thankthemonkey.com/qrcode/", @"link",
                                   @"http://thankthemonkey.com/images/bannerLftImg.png", @"picture",
                                       coupon.title,@"name",
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
         /*
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
          */
     }];
    // Just use the icon image from the application itself.  A real app would have a more 
    // useful way to get an image.
    /*
    UIImage *img = [UIImage imageNamed:@"Icon-72@2x.png"];
    
    [FBRequestConnection startForUploadPhoto:img 
                           completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                               [self showAlert:@"Photo Post" result:result error:error];
                               //self.buttonPostPhoto.enabled = YES;
                           }];
    */
    //self.buttonPostPhoto.enabled = NO;
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
//    [[[googlePlus shareDialog]setPrefillText:[NSString stringWithFormat:@"%@: %@ at %@",coupon.title,coupon.description,businessName]]open];
}

- (void)finishedSharing: (BOOL)shared {
    // Display success message, or ignore.
}

-(void)dealloc
{
    [super dealloc];
    //[loginview release];
    //loginview = nil;
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
