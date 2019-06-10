//
//  PHPhotoLibrary+SaveAndGetVideo.m
//  Eye4
//
//  Created by David on 17/11/2.
//
//

#import "PHPhotoLibrary+SaveAndGetVideo.h"

@implementation PHPhotoLibrary (SaveAndGetVideo)



// 保存图片
+(void)saveVideo:(NSString *)urlStr assetCollection:(NSString *)collectionName result:(void(^)(BOOL success,NSString *identify))result  {
    
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        assetLocalIdentifier = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL URLWithString:urlStr]].placeholderForCreatedAsset.localIdentifier;
        
        NSLog(@"assetIdentifier %@",assetLocalIdentifier);
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success %d error %@",success,error);
        
        if (success == NO) {
            result(NO,assetLocalIdentifier);
            NSLog(@"error %@",error);
            return;
        }
        
        // 2.获得相簿
//        PHAssetCollection *createdAssetCollection = [self createdAssetCollectionWithName:collectionName];
//        if (createdAssetCollection == nil) return;
//        
//        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//            // 3.添加"相机胶卷"中的图片A到"相簿"D中
//            
//            // 获得图片
//            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
//            
//            // 添加图片到相簿中的请求
//            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
//            // 添加图片到相簿
//            [request addAssets:@[asset]];
//            
//            
//        } completionHandler:^(BOOL success, NSError * _Nullable error) {
//            result(success,assetLocalIdentifier);
//        }];
    }];
}

+ (PHAssetCollection *)createdAssetCollectionWithName:(NSString *)collectionName {
    
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:collectionName]) {
            return assetCollection;
        }
    }
    
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}


#pragma mark - 获取视频
+(void)getVideoWithIdentify:(NSString *)assetIdentifier result:(void(^)(NSURL *url))result{
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].lastObject;
    if (asset == nil) {
        result(nil);
        return;
    }
    //获取视频
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [options2 setNetworkAccessAllowed:true];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options2 resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        NSLog(@"asset %@",((AVURLAsset*)asset).URL);//asset为AVURLAsset类型  可直接获取相应视频的相对地址
        //            NSString *path = ((AVURLAsset*)asset).URL.path;//
        result(((AVURLAsset*)asset).URL);
        
    }];
}


@end
