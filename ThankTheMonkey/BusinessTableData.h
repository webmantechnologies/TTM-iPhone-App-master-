//
//  BusinessTableData.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Business.h"

@interface BusinessTableData : Business
{
    NSNumber *distance;
}

@property (nonatomic, retain) NSNumber *distance;

-(id)initWithBusiness:(Business *)b;

@end
