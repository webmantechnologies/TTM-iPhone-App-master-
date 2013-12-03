//
//  ProgressView.m
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

@synthesize progressBar, progressLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
        [progressLabel setTextColor:[UIColor whiteColor]];
        [progressLabel setTextAlignment:UITextAlignmentCenter];
        [progressLabel setBackgroundColor:[UIColor clearColor]];
        //progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 32, 320,16)];
        progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        CGRect frame = CGRectMake(0, 32, 320, 16);
        progressBar.frame = frame;
        [self addSubview:progressLabel];
        [self addSubview:progressBar];
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
