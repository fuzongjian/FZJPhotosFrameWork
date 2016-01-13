//
//  FZJSuperViewController.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/12.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZJSuperViewController : UIViewController

/**
 *   子控器可以拿到返回按钮
 */
@property(nonatomic,strong)UIButton * back;
/**
 *  子控器可以拿到退出按钮
 */
@property(nonatomic,strong)UIButton * quit;




/**
 *  标题设置
 *
 *  @param title 标题
 */
-(void)setCustomTitle:(NSString *)title;



@end
