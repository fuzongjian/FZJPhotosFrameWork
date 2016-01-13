//
//  FZJBigPhotoController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSuperViewController.h"

@interface FZJBigPhotoController : FZJSuperViewController
/**
 *  数据源
 */
@property(nonatomic,strong)NSArray * fetchResult;
/**
 *  已经选择的照片
 */
@property(nonatomic,strong)NSMutableArray <FZJPhotoModel *>* ChooseArr;
/**
 *  能选择照片的上限
 */
@property(nonatomic,assign)NSInteger addNum;

@end
