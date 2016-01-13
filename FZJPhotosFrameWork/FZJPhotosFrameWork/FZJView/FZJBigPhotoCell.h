//
//  FZJBigPhotoCell.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZJBigPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;

-(void)showIndicator;
-(void)hideIndicator;

@end
