//
//  FZJenterAlbumCell.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJenterAlbumCell.h"

@implementation FZJenterAlbumCell

- (void)awakeFromNib {
    _iconImageView.layer.cornerRadius = 5;
    _iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
