//
//  BusinessType.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"

@interface BusinessType : ISModel
{
    NSString *name;
    NSNumber *mediaPartnerId;
    NSString *imageName;
}

@property (nonatomic, retain) NSString *name, *imageName;
@property (nonatomic, retain) NSNumber *mediaPartnerId;

-(NSArray *)businesses;

@end
