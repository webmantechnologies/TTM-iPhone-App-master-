//
//  CouponTableViewCell.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CouponTableViewCell

@synthesize titleLabel, subTitleLabel, infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 9;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowRadius = 4;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
