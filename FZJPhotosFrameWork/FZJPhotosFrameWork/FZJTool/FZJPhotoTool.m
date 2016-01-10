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
//    PHFetchResult * smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    [smartAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] || [collection.localizedTitle isEqualToString:@"Videos"])) {
//           PHFetchResult * result = [self fetchAssetsInAssetCollection:collection ascending:NO];
//            if (result.count > 0) {
//                FZJPhotoList * list = [[FZJPhotoList alloc]init];
//                list.title = [self transformAblumTitle:collection.localizedTitle];
//                list.photoNum = result.count;
//                list.firstAsset = result.firstObject;
//                list.assetCollection = collection;
//                [photoList addObject:list];
//            }
//        }
//    }];
    /**
     *  用户创建的相册
     */
//    PHFetchResult * userAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
//    [userAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
//        PHFetchResult *result = [self fetchAssetsInAssetCollection:collection ascending:NO];
//        if (result.count > 0) {
//            FZJPhotoList * list = [[FZJPhotoList alloc]init];
//            list.title = [self transformAblumTitle:collection.localizedTitle];
//            list.photoNum = result.count;
//            list.firstAsset = result.firstObject;
//            list.assetCollection = collection;
//            [photoList addObject:list];
//
//        }
//    }];
    
    
    return photoList;
}
@end
