//
//  BusinessTableViewCell.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessTableViewCell.h"

@implementation BusinessTableViewCell

@synthesize titleLabel, subTitleLabel, imageView, infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 60, 60)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 10, 165, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.minimumFontSize = 10;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(74, 30, 178, 21)];
        subTitleLabel.backgroundColor = [UIColor clearColor];
        subTitleLabel.font = [UIFont systemFontOfSize:13];
        subTitleLabel.minimumFontSize = 10;
        subTitleLabel.adjustsFontSizeToFitWidth = YES;
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 20, 52, 21)];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:12];
        infoLabel.minimumFontSize = 10;
        infoLabel.adjustsFontSizeToFitWidth = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell1.png"]];
        //self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell1_selected.png"]];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:imageView];
        [self addSubview:titleLabel];
        [self addSubview:subTitleLabel];
        [self addSubview:infoLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
