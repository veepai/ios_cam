//
//  oDropListStruct.h
//  P2PCamera
//
//  Created by mac on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#ifndef P2PCamera_oDropListStruct_h
#define P2PCamera_oDropListStruct_h

@interface param_value_t : NSObject {
    
}
@property(nonatomic,assign) int index;
@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain) NSString *strTitle;
@property(nonatomic,retain) NSString *strValue;
@property(nonatomic,assign) int param1;
@property(nonatomic,assign) int param2;
-(void) InitValue:(int)_index Name:(NSString*)_strName Title:(NSString*)_strTitle Value:(NSString*)_strValue pm1:(int)_param1 pm2:(int)param2;
@end


@interface data_param_value : NSObject {
}

+(id)sharedInstance;

@property(nonatomic,retain) NSArray*  extern_level;
@property(nonatomic,retain) NSArray*  extern_mode;
@property(nonatomic,retain) NSArray*  motion_level;
@property(nonatomic,retain) NSArray*  motion_preset;
@property(nonatomic,retain) NSArray*  pic_timer;
@property(nonatomic,retain) NSArray*  ntp_server;
@property(nonatomic,retain) NSArray*  time_zone;
@property(nonatomic,retain) NSArray*  ssl;
@property(nonatomic,retain) NSArray*  smtp_svr;
@end

#endif
