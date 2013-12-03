//
//  ProgressView.h
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
{
    UILabel *progressLabel;
    UIProgressView *progressBar;
}

@property (nonatomic, retain) UILabel *progressLabel;
@property (nonatomic, retain) UIProgressView *progressBar;

@end
