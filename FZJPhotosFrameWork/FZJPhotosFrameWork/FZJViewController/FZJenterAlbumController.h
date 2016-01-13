//
//  FZJenterAlbumController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnBackPhotoArr)(id data);

@interface FZJenterAlbumController : UITableViewController
/**
 *  所有的相册
 */
@property(nonatomic,strong)NSArray<FZJPhotoList *> * photoList;

/**
 *  所能选择的图片上限
 */
@property(nonatomic,assign)NSInteger addNum;

@property(nonatomic,copy)returnBackPhotoArr returnBlock;

-(void)enterAlbum:(returnBackPhotoArr)block;

@end
