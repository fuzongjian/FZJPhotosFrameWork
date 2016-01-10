//
//  FZJSmallPhotoCell.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSmallPhotoCell.h"

@implementation FZJSmallPhotoCell

- (void)awakeFromNib {
    
    _ImageView.layer.cornerRadius = 5;
    _ImageView.layer.masksToBounds = YES;
    
    
}

@end
