//
//  PHPhotoLibrary+SaveAndGetVideo.h
//  Eye4
//
//  Created by David on 17/11/2.
//
//

#import <Photos/Photos.h>

@interface PHPhotoLibrary (SaveAndGetVideo)

//保存视频
+(void)saveVideo:(NSString *)urlStr assetCollection:(NSString *)collectionName result:(void(^)(BOOL success,NSString *identify))result ;

//获取视频
+(void)getVideoWithIdentify:(NSString *)assetIdentifier result:(void(^)(NSURL *url))result;


@end
