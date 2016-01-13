//
//  FZJSmallPhotoController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/12.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSuperViewController.h"

@interface FZJSmallPhotoController : FZJSuperViewController
/**
 *  小图浏览的相册标题
 */
@property(nonatomic,strong)NSString * smallTitle;
/**
 *  小图浏览的数据源
 */
@property(nonatomic,strong)NSArray * fetchResult;



/**
 *  所能选择的图片上限
 */
@property(nonatomic,assign)NSInteger addNum;



@end
