//
//  MediaPartnerTableViewCell.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaPartnerTableViewCell : UITableViewCell
{
    UILabel *cellLabel;
    UIImageView *mpImageView;
}

@property (nonatomic, retain) UILabel *cellLabel;
@property (nonatomic, retain) UIImageView *mpImageView;

-(void)setMpImage:(UIImage *)mpImage;

@end
