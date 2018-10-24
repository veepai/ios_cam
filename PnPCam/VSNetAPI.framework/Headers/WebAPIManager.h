//
//  WebAPIManager.h
//  Eye4WebAPIManager
//
//  Created by Cuiheng on 16/12/20.
//  Copyright © 2016年 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAPIManager : NSObject

#pragma mark 注册设备

/**
 
 *  注册设备
 
 *
 
 *  @param uid  摄像机UID
 
 *  @param token  APNS token
 
 *  @param language  推送语言
 
 *   @param oemid  oemid
 
 language传值说明:
 以下为各系统语言对应字符串：
 英文：    en
 中文简体：  zh
 中文繁体：  zh_FT
 德文：    de
 西班牙：   es
 法语：    fr
 意大利：   it
 日语：    ja
 韩语：    ko
 俄语：   ru
 荷兰语：   nl
 波兰语：   pl
 泰语：    th
 越南语：   vi
 葡萄牙：   pt_BR
 
 */


+ (void)BingdingDeviceUID:(NSString *)uid Token:(NSString *)token Oemid:(NSString *)oemid Language:(NSString *)language ResultBlockSuccess:(void (^)(id result))success Failure:(void (^)(NSError* error ,NSInteger statusCode ,NSString *resultMessage))failure;

#pragma mark 反注册设备

/**
 
 *  反注册设备
 
 *
 
 *  @param uid  摄像机UID
 
 *  @param token  APNS token
 
 */
+ (void)UnbingdingDeviceUID:(NSString *)uid Token:(NSString *)token Oemid:(NSString *)oemid ResultBlockSuccess:(void (^)(id result))success Failure:(void (^)(NSError* error ,NSInteger statusCode ,NSString *resultMessage))failure;

/**
 
 *  设备消息记录
 
 *
 
 *  @param uid  摄像机UID
 
 *  @param time  查询时间 1天为单位
 
 */
+ (void)GetMessageDevice:(NSString *)uid Time:(NSString *)time ResultBlockSuccess:(void (^)(id result))success Failure:(void (^)(NSError* error ,NSInteger statusCode ,NSString *resultMessage))failure;

@end
