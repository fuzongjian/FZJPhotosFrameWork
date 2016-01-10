//
//  FZJPhotoTool.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZJPhotoList : NSObject
/**
 *  相册的名字
 */
@property(nonatomic,strong)NSString * title;
/**
 *  该相册的照片数量
 */
@property(nonatomic,assign)NSInteger  photoNum;
/**
 *  该相册的第一张图片
 */
//@property(nonatomic,strong)PHAsset * firstAsset;
///**
// *  同过该属性可以取得该相册的所有照片
// */
//@property(nonatomic,strong)PHAssetCollection * assetCollection;

@end




@interface FZJPhotoTool : NSObject

+(instancetype)defaultFZJPhotoTool;


-(NSArray<FZJPhotoList *> *)getAllPhotoList;



@end
