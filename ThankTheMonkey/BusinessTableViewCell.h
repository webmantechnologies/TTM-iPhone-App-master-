//
//  BusinessTableViewCell.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessTableViewCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UILabel *infoLabel;
    UIImageView *imageView;
}

@property (nonatomic, strong) UILabel *titleLabel, *subTitleLabel, *infoLabel;
@property (nonatomic, retain) UIImageView *imageView;

@end
