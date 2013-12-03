//
//  MediaPartner.h
//  ThankTheMonkey
//
//  Created by Ryan Wall on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISModel.h"

@interface MediaPartner : ISModel
{
    NSString *name;
    NSString *imageName;
    NSString *description;
    NSString *phone;
    NSString *address;
    NSString *website;
    NSNumber *marketId;
    NSString *bannerName;
}

@property (nonatomic, retain) NSString *name, *imageName, *description, *phone, *address, *website, *bannerName;
@property (nonatomic, retain) NSNumber *marketId;

@end
