//
//  BusinessTableData.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 9/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusinessTableData.h"

@implementation BusinessTableData

@synthesize distance;

-(id)initWithBusiness:(Business *)b
{
    self.primaryKey = b.primaryKey;
    self.name = b.name;
    self.imageName = b.imageName;
    self.website = b.website;
    self.description = b.description;
    self.videoId = b.videoId;
    self.businessType = b.businessType;
    self.mediaPartnerId = b.mediaPartnerId;
    return self;
}

@end
