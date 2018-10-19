//
//  APICommon.h
//  P2PCamera
//
//  Created by Tsang on 12-12-11.
//
//

#import <Foundation/Foundation.h>

@interface APICommon : NSObject

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) GetImageByNameFromImage: (NSString*)did filename:(NSString*)filename;
+ (UIImage*) GetPictureByNameFromImage: (NSString*)did filename:(NSString*)filename;
//+ (UIImage*) YUV420ToImage: (Byte*)yuv width:(int)width height:(int)height;

+ (NSString *)stringAnalysisWithFormatStr:(NSString *)FormatStr AndRetString:(NSString *)retString;

+ (NSArray *)stringJsonToArray:(NSString *)retString;

+ (void)writeData:(NSArray *)dataAry toPlistFile:(NSString *)fileName;

+ (void)writeDicData:(NSDictionary *)dataDic toPlistFile:(NSString *)fileName;

+ (NSArray *)readDataFromPlistFile:(NSString *)fileName;

+ (NSDictionary *)readDicDataFromPlistFile:(NSString *)fileName;

+(NSString *)handledScanStr:(NSString *)origanStr;

@end

