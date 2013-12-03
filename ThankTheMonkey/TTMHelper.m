//
//  TTMHelper.m
//  ThankTheMonkey
//
//  Created by Ryan Wall on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTMHelper.h"

@implementation TTMHelper

+(NSString *)getURLForImage:(NSString *)imageName
{
    NSString *url = @"http://ttm.yourmobicity.com/proba2/";
    return [url stringByAppendingString:imageName];
}

+(UIImage *)getImageFromName:(NSString *)imageName
{
    NSRange match;
    NSString *imageBaseName;
    UIImage *image;// = [UIImage imageNamed:imageName];
    if (imageName==nil)
    {
        image=[[UIImage alloc]initWithContentsOfFile:@"monkey.png"];
    }
    else
    {
        match = [imageName rangeOfString: @"/"];
        if (match.location == 0)
            imageBaseName = imageName;
        else{
            imageBaseName = [imageName substringFromIndex:match.location + 1];
            match = [imageBaseName rangeOfString:@"/"];
            if (match.length != 0)
            {
                imageBaseName = [imageBaseName substringFromIndex:match.location + 1];
            }
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
        NSString *documentsFolder = [paths objectAtIndex:0];
    
        if ([[NSFileManager defaultManager] fileExistsAtPath:[documentsFolder stringByAppendingPathComponent:imageBaseName]]) {
            image = [UIImage imageWithContentsOfFile: [documentsFolder stringByAppendingPathComponent:imageBaseName]];
    }
        else {
            NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:imageName]]];
            image = [[UIImage alloc] initWithData:receivedData];
            NSData *pngFile = UIImagePNGRepresentation(image);
            NSLog(@"MP image is %@", imageBaseName);
            NSLog(@"MP full image is %@",[@"http://ttm.yourmobicity.com/proba2/" stringByAppendingString:imageName]);
        
            //NSLog(@"to be copied to %@", documentsFolder);
            [pngFile writeToFile:[documentsFolder stringByAppendingPathComponent:imageBaseName] atomically:YES];
        }
    }
    
    return image;
}

@end
