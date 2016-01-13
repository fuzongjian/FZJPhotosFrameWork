//
//  FZJSuperViewController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/12.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSuperViewController.h"

@implementation FZJSuperViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configSuperViewControllerUI];
}
-(void)configSuperViewControllerUI{
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, 44, 44);
    [back addTarget:self action:@selector(SuperBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    _back = back;
    
    
    UIButton * quit = [UIButton buttonWithType:UIButtonTypeSystem];
    [quit setTitle:@"取消" forState:UIControlStateNormal];
    quit.frame = CGRectMake(0, 0, 44, 44);
    [quit addTarget:self action:@selector(backToRootController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:quit];
    _quit = quit;
}
/**
 *  返回上一级界面
 */
-(void)SuperBackBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  返回到第一个界面
 */
-(void)backToRootController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  标题设置
 *
 *  @param title 标题
 */
-(void)setCustomTitle:(NSString *)title{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = label;
    
}
@end
