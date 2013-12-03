//
//  CategoryTableViewCell.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
{
    UILabel *cellLabel;
    UILabel *countLabel;
    UIImageView *categoryIcon;
}

@property (nonatomic, retain) UILabel *cellLabel, *countLabel;
@property (nonatomic, retain) UIImageView *categoryIcon;

-(void)setCategoryIconImage:(UIImage *)catImage;

@end
