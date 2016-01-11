//
//  FZJPhotoModel.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/11.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZJPhotoModel : NSObject
/**
 *  通过asset取到照片
 */
@property(nonatomic,strong)PHAsset * asset;
/**
 *  照片的名字
 */
@property(nonatomic,strong)NSString * imageName;

@end
