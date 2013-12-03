//
//  AppDatabase.m
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDatabase.h"
#import <zlib.h>
#import <CommonCrypto/CommonDigest.h>
#import "TTMAppDelegate.h"

@implementation AppDatabase

@synthesize databasePath,databaseName,localMD5,remoteMD5,md5Conn,sqlFileConn;
@synthesize finishedLoading;

int dbSize;

- (id)init {
    [self setDatabaseVars];
    [self checkAndCreateDatabase];
    if (self = [super initWithFileName:@"/ThankTheMonkey.sqlite"]) {
        [self open];
        NSLog(@"Setting the ISModel database.");
        [ISModel setDatabase:self];
    }
    return self;
}

- (void)setDatabaseVars {
	NSLog(@"init:We are initializing the db variables");
	//Set up global varibles
    if (connectionToInfoMapping == nil)
        connectionToInfoMapping = CFDictionaryCreateMutable(
                                                            kCFAllocatorDefault,
    														0,
    														&kCFTypeDictionaryKeyCallBacks,
    														&kCFTypeDictionaryValueCallBacks);
    
	databaseName = @"ThankTheMonkey.sqlite";
	
	//Get the path to documents directory and append the database name
	NSArray *the_pDocumentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	the_pDocumentsDir = [the_pDocumentPaths objectAtIndex:0];
	databasePath = [the_pDocumentsDir stringByAppendingPathComponent:databaseName];
}

- (void)checkAndCreateDatabase
{
    NSLog(@"Checking and creating the database");
    //start the boolean value as false
    finishedLoading = false;
	//Check if the SQL database is available on the Iphone, if not the copy it over
	BOOL the_bSuccess;
	
    
	//Crete filemaker object and we will use to check if the database is available on the user‚Äôs iPhone, if not the copy it over
	NSFileManager *the_pFileManager = [NSFileManager defaultManager];
    
    the_bSuccess = [the_pFileManager fileExistsAtPath:databasePath];
    NSString *the_pDatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    if(!the_bSuccess) 
	{
        //This should happen only first time app is opened.
        //If it doesn't exist then proceed to copy the database from the application to user‚Äôs filesystem
        //Get the path to the database in the application package
        
        //Copy the database from the package to the user‚Äôs filesystem
        [the_pFileManager copyItemAtPath:the_pDatabasePathFromApp toPath:databasePath error:nil];
    }
    else {
        
        
        //Check the date of the file in the bundle and in documents folder, to compare databases and move the newest one
        // For first time only, while upgrading the app
        
        NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:databasePath error:nil];
        NSString *resultDocuments = [fileAttribs valueForKey:NSFileModificationDate];
        NSLog(@"Database in Documents folder: %@",resultDocuments);
        
        
        fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:the_pDatabasePathFromApp error:nil];
        NSString *resultBundle = [fileAttribs valueForKey:NSFileModificationDate];
        NSLog(@"Database in Bundle folder: %@",resultBundle);
        
        //Check if the database is already exists in the user‚Äôs filesystem i.e documents directory of the application
        NSLog(@"Database name is %@ and the path is %@", databaseName, databasePath);
        //If database is already exist then return without doing anything
        
        if([resultDocuments compare:resultBundle] == NSOrderedAscending) {
            NSLog(@"Document's database is older, copy from %@ to %@", the_pDatabasePathFromApp, databasePath);
            [the_pFileManager removeItemAtPath:databasePath error:nil];
            [the_pFileManager copyItemAtPath:the_pDatabasePathFromApp toPath:databasePath error:nil];
            
        }
        else
            NSLog(@"Document's database is newer");
    }
    
    
	
    //Calculate file's MD5 checksum
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:databasePath];
    if( handle == nil ) NSLog(@"ERROR GETTING FILE MD5"); // file didnt exist
    CC_MD5_CTX md5;
    
	CC_MD5_Init(&md5);
	
	BOOL done = NO;
    NSData *fileData;
	while(!done)
	{
        
        fileData = [[[NSData alloc] initWithData:[handle readDataOfLength:4096]]autorelease];
        
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        
        if( [fileData length] == 0 )
        {
            done = YES;
        }
        
    }
    
    
    // [fileData release];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    localMD5 = [[NSString alloc] initWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                digest[0], digest[1], 
                digest[2], digest[3],
                digest[4], digest[5],
                digest[6], digest[7],
                digest[8], digest[9],
                digest[10], digest[11],
                digest[12], digest[13],
                digest[14], digest[15]];
    NSLog(@"MD5 is %@", localMD5);
    
    //responseData = [[NSMutableData data] retain];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ttm.yourmobicity.com/ThankTheMonkey.sqlite.md5"] cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:15.0];
	md5Conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    CFDictionaryAddValue(
                         connectionToInfoMapping,
                         md5Conn,
                         [NSMutableDictionary
                          dictionaryWithObject:[NSMutableData data]
                          forKey:@"md5Data"]);
    
}

- (void)connection: (NSURLConnection*) connection didReceiveResponse: (NSHTTPURLResponse*) response
{
    int statusCode_ = [response statusCode];
    if (statusCode_ == 200) {
        dbSize = [response expectedContentLength];
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //add the data to the corresponding NSURLConnection object
	const NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
    [self setDatabaseVars];
    
    //  NSLog(@"Database path is %@", databasePath);
	if ([connectionInfo objectForKey:@"md5Data"] != nil) {
        
		[[connectionInfo objectForKey:@"md5Data"] appendData:data];
        NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"MD5 on the Server is %@, is it equal to local MD5 (%@)? %@", responseString, localMD5, ([localMD5 isEqualToString:responseString]? @"YES" : @"NO"));
        //TODO: Use regular expression to ensure it is not an md5
        if ([responseString length] != [localMD5 length])
        {
            NSLog(@"Not a valid MD5, use the old database");
            TTMAppDelegate *the_pAppDelegate = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
            [the_pAppDelegate finishedUpdatingDatabase];
            finishedLoading = TRUE;
        }
        else if ([localMD5 isEqualToString:responseString]) {
            NSLog(@"It is equal, don't do anything");
            TTMAppDelegate *the_pAppDelegate = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
            [the_pAppDelegate finishedUpdatingDatabase];
            finishedLoading = TRUE;
            
        }
        else {
            NSLog(@"It is different, download new SQLite");
            NSFileManager *the_pFileManager = [NSFileManager defaultManager];
            [the_pFileManager removeItemAtPath:databasePath error:NULL];
            
            
            NSString *zippedDBPath = [databasePath stringByAppendingString:@".gz"];
            [the_pFileManager createFileAtPath:zippedDBPath contents:nil attributes:nil];
            file = [[NSFileHandle fileHandleForUpdatingAtPath:zippedDBPath] retain];
            if (file)   {
                
                [file seekToEndOfFile];
            }
            //           [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ttm.yourmobicity.com/ThankTheMonkey.sqlite"]];
            sqlFileConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];           
            TTMAppDelegate *the_pAppDelegate = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
            [the_pAppDelegate.progressView setHidden:FALSE];
            CFDictionaryAddValue(
                                 connectionToInfoMapping,
                                 sqlFileConn,
                                 [NSMutableDictionary
                                  dictionaryWithObject:[NSMutableData data]
                                  forKey:@"sqlFileData"]);
        }    
    }
	else if ([connectionInfo objectForKey:@"sqlFileData"] != nil) {
		[[connectionInfo objectForKey:@"sqlFileData"] appendData:data];
        float progress = ((float) [[connectionInfo objectForKey:@"sqlFileData"] length] / (float) dbSize);
        TTMAppDelegate *del = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [del.progressView.progressBar setProgress:progress];
        //NSLog(@"Received SQLite File, we are about to write a file in %@", databasePath);
        //NSFileManager *the_pFileManager = [NSFileManager defaultManager];
        //[the_pFileManager createFileAtPath:databasePath  contents:data attributes:nil];
        //[data writeToFile:databasePath atomically:YES];
        if (file)  { 
            // NSLog(@"Downloading compressed SQLite");
            [file seekToEndOfFile];
        } 
        [file writeData:data]; 
        // [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    TTMAppDelegate *the_pAppDelegate = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [the_pAppDelegate finishedUpdatingDatabase];
    NSLog(@"Connection failed: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    finishedLoading=true;
    /*SteubenvilleCityAppDelegate *the_pAppDelegate = (SteubenvilleCityAppDelegate *)[[UIApplication sharedApplication] delegate];
     [the_pAppDelegate finishedUpdatingDatabase];*/
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
      // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    const NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
    
    if ([connectionInfo objectForKey:@"sqlFileData"] != nil) {
        [self setDatabaseVars];  
        NSString *zippedDBPath = [databasePath stringByAppendingString:@".gz"];
        NSFileManager *the_pFileManager = [NSFileManager defaultManager];
        
        [the_pFileManager moveItemAtPath:zippedDBPath toPath:databasePath error:nil];
        
        
        NSLog(@"(Auto Decompressed and renamed)Finished Download DataBase at: %@", databasePath);
        
        NSDictionary *fileAttributes = [the_pFileManager attributesOfItemAtPath:databasePath error:nil];
        
        NSLog(@"(DidFinishLoading) Size of unzipped file is %@", [fileAttributes objectForKey:@"NSFileSize"]);
        TTMAppDelegate *the_pAppDelegate = (TTMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [the_pAppDelegate finishedUpdatingDatabase];
        [self close];
        [self open];
        [ISModel setDatabase:self];
        [connection release];
        finishedLoading=true;
    }
    else if ([connectionInfo objectForKey:@"md5Data"] != nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    
    //    [del.navigationController   
}

-(id)delegate
{
    return delegate;
}

-(void)setDelegate:(id)newDelegate
{
    delegate = newDelegate;
}

@end
