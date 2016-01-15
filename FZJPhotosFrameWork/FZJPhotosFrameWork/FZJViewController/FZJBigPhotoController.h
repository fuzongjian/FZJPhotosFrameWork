//
//  FZJBigPhotoController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSuperViewController.h"

typedef void (^returnBackPhotoArr)(id data);


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
/**
 *  点击的图片
 */
@property(nonatomic,assign)NSInteger clickNum;

/**
 *  YES则为从第一个界面进入大图浏览，否则是从小图浏览直接进入大图浏览
 */
@property(nonatomic,assign)BOOL chooseState;


@property(nonatomic,copy)returnBackPhotoArr returnBlock;
@property(nonatomic,copy)returnBackPhotoArr rootBlock;

-(void)returnBack:(returnBackPhotoArr)block;
-(void)returnToRoot:(returnBackPhotoArr)rootBlock;

@end
