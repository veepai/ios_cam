//
//  SearchListMgt.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchListMgt : NSObject {
    
@private
    NSMutableArray *CameraArray;
    
}

- (BOOL) AddCamera: (NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did ;
- (BOOL) AddVuidCamera: (NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString*)did VUID:(NSString*)strVid ;
- (int) GetCount;
- (NSDictionary*) GetCameraAtIndex:(NSInteger) index;
- (BOOL)CheckCamere:(NSString *)addr Port:(NSString *)port;
- (void)ClearList;


@end
