//
//  FZJHeader.h
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#ifndef FZJHeader_h
#define FZJHeader_h

/**
 *  适配机型
 *
 */


#define iPHone6Plus ([UIScreen mainScreen].bounds.size.height == 736) ? YES : NO

#define iPHone6 ([UIScreen mainScreen].bounds.size.height == 667) ? YES : NO

#define iPHone5 ([UIScreen mainScreen].bounds.size.height == 568) ? YES : NO

#define iPHone4oriPHone4s ([UIScreen mainScreen].bounds.size.height == 480) ? YES : NO


#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *  屏幕宽
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

/**
 *  屏幕高
 */
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#endif /* FZJHeader_h */
