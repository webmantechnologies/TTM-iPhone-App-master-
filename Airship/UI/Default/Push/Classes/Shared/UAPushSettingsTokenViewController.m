/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UAPushSettingsTokenViewController.h"
#import "UAirship.h"

@implementation UAPushSettingsTokenViewController

@synthesize emailButton;
@synthesize tokenLabel;

- (void)dealloc {
    RELEASE_SAFELY(emailButton);
    RELEASE_SAFELY(tokenLabel);
    RELEASE_SAFELY(text);
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float == 7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Device Token";

    text = @"Your current device token. Test a push notification at "
           @"https://go.urbanairship.com";

    tokenLabel.text = [UAirship shared].deviceToken ? [UAirship shared].deviceToken : @"Unavailable";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.emailButton = nil;
    self.tokenLabel = nil;
}

#pragma mark -
#pragma mark UITableViewDelegate

#define kCellPaddingHeight 10

- (CGFloat)tableView: (UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    UIFont *font = [UIFont systemFontOfSize:17];
    CGFloat height = [text sizeWithFont:font
                      constrainedToSize:CGSizeMake(280.0, 1500.0)
                          lineBreakMode:UILineBreakModeWordWrap].height;
    return height + kCellPaddingHeight;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *bgImage = [UIImage imageNamed:@"middle-detail.png"];
    UIImage *stretchableBgImage = [bgImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage: stretchableBgImage];

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"description-cell"];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"description-cell"] autorelease];
    }
    
    UIFont *font = [UIFont systemFontOfSize: 17];

    UILabel* description = [[UILabel alloc] init];
    description.text = text;
    description.lineBreakMode = UILineBreakModeWordWrap;
    description.numberOfLines = 0;
    description.backgroundColor = [UIColor clearColor];
    [description setFont: font];
    CGFloat height = [text sizeWithFont:font
                      constrainedToSize:CGSizeMake(280.0, 800.0)
                          lineBreakMode:UILineBreakModeWordWrap].height;
    [description setFrame: CGRectMake(0.0f, 10.0f, 320.0f, height)];
    [description setBounds: CGRectMake(0.20f, 0.0f, 290.0f, height)];
    [description setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    [cell addSubview: description];
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    [cell setBackgroundView: bgImageView];
    cell.backgroundColor=[UIColor clearColor];
    [description release];
    [bgImageView release];

    return cell;
}

#pragma mark -
#pragma mark UI Button Actions
- (IBAction)copyDeviceToken {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [UAirship shared].deviceToken;
}

- (IBAction)emailDeviceToken {

    if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mfViewController = [[MFMailComposeViewController alloc] init];
		mfViewController.mailComposeDelegate = self;
        
        
        
        NSString *messageBody = [NSString stringWithFormat:@"Your device token is %@\n\nSend a test push at http://go.urbanairship.com", [UAirship shared].deviceToken];
        
        [mfViewController setSubject:@"Device Token"];
        [mfViewController setMessageBody:messageBody isHTML:NO];
		
		[self presentViewController:mfViewController animated:YES completion:nil];
		[mfViewController release];
	}else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your device is not currently configured to send mail." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Status" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	switch (result) {
		case MFMailComposeResultCancelled:
			//alert.message = @"Canceled";
			break;
		case MFMailComposeResultSaved:
			//alert.message = @"Saved";
			break;
		case MFMailComposeResultSent:
			alert.message = @"Sent";
            [alert show];
			break;
		case MFMailComposeResultFailed:
			//alert.message = @"Message Failed";
			break;
		default:
			//alert.message = @"Message Not Sent";
        break;	
    }
    
	[self dismissViewControllerAnimated:YES completion:nil];
	

	[alert release];
}

@end
