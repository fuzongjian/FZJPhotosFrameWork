//
//  FZJBigPhotoCell.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJBigPhotoCell.h"

@implementation FZJBigPhotoCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showIndicator{
    self.Indicator.hidden = NO;
    [self.Indicator startAnimating];
}
-(void)hideIndicator{
    [self.Indicator stopAnimating];
}
@end
