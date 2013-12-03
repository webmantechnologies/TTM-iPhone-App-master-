//
//  CouponTableViewCell.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponTableViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subTitleLabel;
    IBOutlet UILabel *infoLabel;
}

@property (nonatomic, strong) IBOutlet UILabel *titleLabel, *subTitleLabel, *infoLabel;



@end
