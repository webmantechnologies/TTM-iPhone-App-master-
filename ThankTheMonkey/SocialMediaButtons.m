//
//  SocialMediaButtons.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocialMediaButtons.h"


@implementation SocialMediaButtons

@synthesize target;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 0, 42, 42)];
        emailButton.backgroundColor = [UIColor clearColor];
        [emailButton setImage:[UIImage imageNamed:@"email_icon.png"] forState:UIControlStateNormal];
        [emailButton addTarget:target action:@selector(emailCoupon) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *smsButton = [[UIButton alloc] initWithFrame:CGRectMake(47, 0, 42, 42)];
        smsButton.backgroundColor = [UIColor clearColor];
        [smsButton setImage:[UIImage imageNamed:@"sms_icon.png"] forState:UIControlStateNormal];
        [smsButton addTarget:target action:@selector(smsCoupon) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 42, 42)];
        fbButton.backgroundColor = [UIColor clearColor];
        [fbButton setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
        [fbButton addTarget:target action:@selector(facebookCoupon) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *twButton = [[UIButton alloc] initWithFrame:CGRectMake(132, 0, 42, 42)];
        twButton.backgroundColor = [UIColor clearColor];
        [twButton setImage:[UIImage imageNamed:@"twitter_icon.png"] forState:UIControlStateNormal];
        [twButton addTarget:target action:@selector(tweetCoupon) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *gpButton = [[UIButton alloc] initWithFrame:CGRectMake(174, 0, 42, 42)];
        gpButton.backgroundColor = [UIColor clearColor];
        [gpButton setImage:[UIImage imageNamed:@"google_plus_icon.png"] forState:UIControlStateNormal];
        [gpButton addTarget:target action:@selector(googlePlusCoupon) forControlEvents:UIControlEventTouchUpInside];
        
         
        /*
        UIButton *fsButton = [[UIButton alloc] initWithFrame:CGRectMake(216, 142, 42, 42)];
        fsButton.backgroundColor = [UIColor clearColor];
        [fsButton setImage:[UIImage imageNamed:@"foursquare_icon.png"] forState:UIControlStateNormal];
        
        UIButton *igButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 142, 42, 42)];
        igButton.backgroundColor = [UIColor clearColor];
        [igButton setImage:[UIImage imageNamed:@"instagram_icon.png"] forState:UIControlStateNormal];
         */
        
        [self addSubview:emailButton];
        [self addSubview:smsButton];
        [self addSubview:fbButton];
        [self addSubview:twButton];
        [self addSubview:gpButton];
        /*
        [self addSubview:fsButton];
        [self addSubview:igButton];
         */
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
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
