//
//  MediaPartnerTableViewCell.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaPartnerTableViewCell.h"

@implementation MediaPartnerTableViewCell

@synthesize mpImageView,cellLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 60);
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mediapartner_cell_bg.png"]];
        self.backgroundColor = [UIColor whiteColor];
        
        mpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(92, 4, 136, 50)];
         mpImageView.contentMode = UIViewContentModeScaleToFill;
        [self.mpImageView setImage:[UIImage imageNamed:@"-1.1.png"]];
        [self addSubview:mpImageView];

        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 77, 21)];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.font = [UIFont italicSystemFontOfSize:12.0];
       // cellLabel.text = @"Presented By:";
        [self addSubview:cellLabel];
    }
    return self;
}

-(void)setMpImage:(UIImage *)mpImage
{
//    self.mpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(92, 9, 136, 42)];
//    mpImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.mpImageView setImage:mpImage];
//    [self addSubview:mpImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
