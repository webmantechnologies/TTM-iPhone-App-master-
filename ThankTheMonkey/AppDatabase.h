//
//  AppDatabase.h
//  SteubenvilleCityApp
//
//  Created by Ryan Wall on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ISDatabase.h"
#import "ISModel.h"

@protocol AppDatabaseDelegate <NSObject>

-(void)finishedLoadingDatabase;

@end

@interface AppDatabase : ISDatabase{
    NSString *databasePath;
    NSString *databaseName;
    NSString *localMD5;
    NSString *remoteMD5;
    NSString *the_pDocumentsDir;
    NSURLConnection *md5Conn,*sqlFileConn;
    NSFileHandle *file;
    BOOL finishedLoading;
    CFMutableDictionaryRef connectionToInfoMapping;
    id <AppDatabaseDelegate> delegate;
}

@property (nonatomic, retain) NSString *databasePath,*databaseName,*localMD5,*remoteMD5;
@property (nonatomic, assign) BOOL finishedLoading;
@property (nonatomic, retain) NSURLConnection *md5Conn,*sqlFileConn;

- (void)checkAndCreateDatabase;
- (BOOL)isDBConnected;
- (void)setDatabaseVars;

-(id)delegate;
-(void)setDelegate:(id)newDelegate;

@end
