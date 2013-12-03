//
//  TTMTitleView.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMTitleView.h"

@implementation TTMTitleView

- (id)init
{
    [self initWithFrame:CGRectMake(0, 0, 180, 44)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
        UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monkey_banner.png"]];
        self.contentMode = UIViewContentModeScaleAspectFit;
        titleImage.frame = CGRectMake(0, 0, 180, 44);
        [self addSubview:titleImage];
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
