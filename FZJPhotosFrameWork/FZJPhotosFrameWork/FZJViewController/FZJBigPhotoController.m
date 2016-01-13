//
//  FZJBigPhotoController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/13.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJBigPhotoController.h"
#import "FZJBigPhotoCell.h"
/**
 * 宏定义间距
 */
#define margin 30

@interface FZJBigPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
/**
 *  大图展示以供选择
 */
@property(nonatomic,strong)UICollectionView * bigCollect;
/**
 *  展示当前选择照片的动态
 */
@property(nonatomic,strong)UILabel * middle;
/**
 *  导航栏右侧的按钮
 */
@property(nonatomic,strong)UIButtonExt * selectStatus;

@end

@implementation FZJBigPhotoController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self configBigPhotoControllerUI];
    [self showSelectedStatusUI];
}
#pragma mark --
#pragma mark 初始化UI
-(void)configBigPhotoControllerUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, margin/2, 0, margin/2);
    flowLayout.itemSize = self.view.size;
    
    _bigCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(-margin/2, 0, SCREEN_WIDTH + margin, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    [_bigCollect registerNib:[UINib nibWithNibName:@"FZJBigPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"BigPhotoCell"];
     _bigCollect.pagingEnabled = YES;
    _bigCollect.dataSource = self;
    _bigCollect.delegate = self;
    [self.view addSubview:_bigCollect];
    
    UIButtonExt * quit = [UIButtonExt buttonWithType:UIButtonTypeCustom];
    [quit setBackgroundImage:[UIImage imageNamed:@"No"] forState:UIControlStateNormal];
    [quit setBackgroundImage:[UIImage imageNamed:@"AssetsPickerChecked"] forState:UIControlStateSelected];
    quit.frame = CGRectMake(0, 0, 30, 30);
    [quit addTarget:self action:@selector(selectStatus:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:quit];
    _selectStatus = quit;
    
}
-(void)showSelectedStatusUI{
    UIView * showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:showView];
    
    UILabel * middle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.3, 0, SCREEN_WIDTH * 0.4, 30)];
    middle.textAlignment = NSTextAlignmentCenter;
    middle.text = [NSString stringWithFormat:@"%d/%d",(int)self.ChooseArr.count,(int)self.addNum];
    _middle = middle;
    [showView addSubview:middle];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeSystem];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    sure.frame = CGRectMake(SCREEN_WIDTH * 0.8, 0, SCREEN_WIDTH * 0.2, 30);
    sure.titleLabel.textAlignment = NSTextAlignmentCenter;
    [sure addTarget:self action:@selector(sureBtnClickBackToRoot) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:sure];
    
}
#pragma mark--
#pragma mark 数据请求

#pragma mark--
#pragma mark 数据加载

#pragma mark--
#pragma mark 事件

#pragma mark ---  确定则直接返回到第一个界面显示照片
-(void)sureBtnClickBackToRoot{
    if (self.returnBlock && self.ChooseArr.count) {
        self.returnBlock(self.ChooseArr);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark ---  大图浏览对图片的增删改查

-(void)selectStatus:(UIButtonExt *)select{
    select.selected = !select.selected;
    if (select.selected) {
        FZJPhotoModel * model = [[FZJPhotoModel alloc]init];
        model.asset = self.fetchResult[select.index];
        model.imageName = [self.fetchResult[select.index] valueForKey:@"filename"];
        [self.ChooseArr addObject:model];
    }else{
        for (FZJPhotoModel * model in self.ChooseArr) {
            if ([model.imageName isEqualToString:[self.fetchResult[select.index] valueForKey:@"filename"]]) {
                [self.ChooseArr removeObject:model];
            }
        }
    }
    _middle.text = [NSString stringWithFormat:@"%d/%d",(int)self.ChooseArr.count,(int)self.addNum];
    NSLog(@"----%@",self.ChooseArr);
}
#pragma mark ---  重写父类返回按钮点击事件

-(void)SuperBackBtnClicked{
    
    if (self.returnBlock && self.ChooseArr.count) {
        self.returnBlock(self.ChooseArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)returnBack:(returnBackPhotoArr)block{
    self.returnBlock = block;
}
#pragma mark--
#pragma mark  代理
#pragma mark --- collectionView 代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchResult.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FZJBigPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BigPhotoCell" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    self.selectStatus.selected = NO;
    self.selectStatus.index = indexPath.row;
    [cell showIndicator];
    [[FZJPhotoTool defaultFZJPhotoTool] getImageByAsset:self.fetchResult[indexPath.row] makeSize:PHImageManagerMaximumSize makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *AssetImage) {
        cell.ImageView.image = AssetImage;
        [cell hideIndicator];
    }];
    for (FZJPhotoModel * model in self.ChooseArr) {
        if ([model.imageName isEqualToString:[self.fetchResult[indexPath.row] valueForKey:@"filename"]]) {
            self.selectStatus.selected = YES;
        }
    }
    cell.ScrollView.delegate = self;
    [self addGestureTapToScrollView:cell.ScrollView];
    return cell;
}
#pragma mark --- ScrollView 代理
/**
 *  即将出现的不被方法或者缩小的视图
 *
 *  @param cell           将要出现的Cell
 *  @param indexPath      cell在数据源中得位置
 */
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    FZJBigPhotoCell * WillCell = (FZJBigPhotoCell *)cell;
    WillCell.ScrollView.zoomScale = 1;
}
/**
 *  返回的是图片的视图
 *
 *  @param scrollView 当前的scrollView
 *
 *  @return 返回一个放大或缩小的视图
 */
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews[0];
}
#pragma mark ---  scrollView 添加手势
-(void)addGestureTapToScrollView:(UIScrollView *)scrollView{
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapOnScrollView:)];
    singleTap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapOnScrollView:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
}
/**
 *  隐藏导航栏和NavgationBar
 *
 *  @param singleTap 单击
 */
-(void)singleTapOnScrollView:(UITapGestureRecognizer *)singleTap{
    if (self.navigationController.navigationBar.isHidden) {
        [self showNavBarAndStatusBar];
    }else{
        [self hideNavBarAndStatusBar];
    }
}
#pragma mark ---  隐藏或者显示导航栏
-(void)showNavBarAndStatusBar{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}
-(void)hideNavBarAndStatusBar{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}
/**
 *  放大缩小
 *
 *  @param doubleTap 双击
 */
-(void)doubleTapOnScrollView:(UITapGestureRecognizer *)doubleTap{
    
    UIScrollView * scrollView = (UIScrollView *)doubleTap.view;
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3) {
        scale = 3;
    }else{
        scale = 1;
    }
    [self CGRectForScale:scale WithCenter:[doubleTap locationInView:doubleTap.view] ScrollView:scrollView Completion:^(CGRect Rect) {
        [scrollView zoomToRect:Rect animated:YES];
    }];
}
-(void)CGRectForScale:(CGFloat)scale WithCenter:(CGPoint)center ScrollView:(UIScrollView *)scrollView Completion:(void(^)(CGRect Rect))completion{
    CGRect Rect;
    Rect.size.height = scrollView.frame.size.height / scale;
    Rect.size.width  = scrollView.frame.size.width  / scale;
    Rect.origin.x    = center.x - (Rect.size.width  /2.0);
    Rect.origin.y    = center.y - (Rect.size.height /2.0);
    completion(Rect);
}
#pragma mark--
#pragma mark 通知注册及销毁



@end
