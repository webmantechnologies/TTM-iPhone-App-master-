//
//  Coupon.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"

@interface Coupon : ISModel
{
    NSNumber *businessId;
    NSString *title;
    NSString *description;
    NSDate *startDate;
    NSDate *endDate;
    NSString *imageName;
}

@property (nonatomic, retain) NSNumber *businessId;
@property (nonatomic, retain) NSString *title, *description, *imageName;
@property (nonatomic, retain) NSDate *startDate, *endDate;

@end
