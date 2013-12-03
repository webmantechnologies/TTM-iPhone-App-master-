//
//  CategoryTableViewCell.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

@synthesize categoryIcon,cellLabel,countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320, 50);
        //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell1.png"]];
        CGRect frame = self.backgroundView.frame;
        frame.size.height = 50;
        self.backgroundView.frame = frame;
        //self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell1_selected.png"]];
        self.selectedBackgroundView.frame = frame;
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 184, 20)];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.font = [UIFont boldSystemFontOfSize:20.0];
        cellLabel.textColor = [UIColor brownColor];
        //cellLabel.shadowColor = [UIColor blackColor];
        //cellLabel.shadowOffset = CGSizeMake(1,1);
        cellLabel.adjustsFontSizeToFitWidth = YES;
        cellLabel.text = @"Presented By:";
        
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 12,40, 20)];
        countLabel.textAlignment = UITextAlignmentRight;
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.font = [UIFont boldSystemFontOfSize:18.0];
        countLabel.textColor = [UIColor brownColor];
        //countLabel.shadowColor = [UIColor blackColor];
        //countLabel.shadowOffset = CGSizeMake(1,1);
        countLabel.adjustsFontSizeToFitWidth = YES;
        countLabel.text = @"Presented By:";
        
        categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        categoryIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:categoryIcon];
        
        [self addSubview:cellLabel];
        [self addSubview:countLabel];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

-(void)setCategoryIconImage:(UIImage *)catImage
{
    [self.categoryIcon setImage:catImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
