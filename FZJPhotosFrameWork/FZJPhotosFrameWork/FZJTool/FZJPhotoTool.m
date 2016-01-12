//
//  FZJPhotoTool.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJPhotoTool.h"

@implementation FZJPhotoList



@end


@implementation FZJPhotoTool
+(instancetype)defaultFZJPhotoTool{
    
    static FZJPhotoTool * manager = nil;
    
    @synchronized(manager) {
        if (manager == nil) {
            manager = [[self alloc]init];
        }
    }
    return manager;
    
}
- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    return nil;
}
- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
    return result;
}
-(NSArray<FZJPhotoList *> *)getAllPhotoList{
    
    NSMutableArray<FZJPhotoList *> * photoList = [NSMutableArray array];
    /**
     *  获取多有的系统相册
     */
    PHFetchResult * smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] || [collection.localizedTitle isEqualToString:@"Videos"])) {
           PHFetchResult * result = [self fetchAssetsInAssetCollection:collection ascending:NO];
            if (result.count > 0) {
                FZJPhotoList * list = [[FZJPhotoList alloc]init];
                list.title = [self transformAblumTitle:collection.localizedTitle];
                list.photoNum = result.count;
                list.firstAsset = result.firstObject;
                list.assetCollection = collection;
                [photoList addObject:list];
            }
        }
    }];
    /**
     *  用户创建的相册
     */
    PHFetchResult * userAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *result = [self fetchAssetsInAssetCollection:collection ascending:NO];
        if (result.count > 0) {
            FZJPhotoList * list = [[FZJPhotoList alloc]init];
            list.title = [self transformAblumTitle:collection.localizedTitle];
            if (list.title == nil) {
                list.title = collection.localizedTitle;
            }
            list.photoNum = result.count;
            list.firstAsset = result.firstObject;
            list.assetCollection = collection;
            [photoList addObject:list];

        }
    }];
    
    
    return photoList;
}
#pragma mark ---   获取asset相对应的照片
-(void)getImageByAsset:(PHAsset *)asset makeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    option.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];

}

#pragma mark ----  取到所有的asset资源
- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [assets addObject:asset];
    }];
    
    return assets;
}

#pragma mark ---  获得指定相册的所有照片

- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending{
    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
    
    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    return arr;
}
@end
