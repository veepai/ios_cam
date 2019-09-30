//
//  SearchAddCameraInfoProtocol.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright Company MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchAddCameraInfoProtocol <NSObject>

- (void) AddCameraInfo: (NSString*) strCameraName DID: (NSString*) strDID;

@end
