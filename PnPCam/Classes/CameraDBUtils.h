//
//  CameraDBUtils.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBSelectResultProtocol.h"

@interface CameraDBUtils : NSObject {

    sqlite3 *db;
    NSString *DatabaseName;
    NSString *TableName;
    
    id<DBSelectResultProtocol> selectDelegate;
}

@property (nonatomic, copy) NSString *DatabaseName;
@property (nonatomic, copy) NSString *TableName;
@property (nonatomic, retain) id<DBSelectResultProtocol> selectDelegate;

- (BOOL)Open:(NSString *)dbName TblName:(NSString *)tblName;
- (void)Close;
- (BOOL)OpenDatabase:(NSString *)dbName;
- (BOOL)CreateTable:(NSString *)tbName;
- (NSString *)DatabaseFilePath:(NSString *)dbName;
- (BOOL) InsertCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd tmp:(NSString*)tmpDid time:(NSString*) strTime;
- (BOOL) UpdateCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid;
- (BOOL)UpdateVUIDCameraLastConnetTime:(NSString *)did tmpDID:(NSString *)strTmpdid Time:(NSString *)lastTime;
- (BOOL) RemoveCamera:(NSString *)did;
- (void) SelectAll;
                                                                                                              

@end
