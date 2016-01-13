//
//  FZJSmallPhotoController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/12.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJSmallPhotoController.h"
#import "FZJSmallPhotoCell.h"
#import "UIButtonExt.h"
@interface FZJSmallPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  创建collectionView用于展示
 */
@property(nonatomic,strong)UICollectionView * smallCollect;

@end
@implementation FZJSmallPhotoController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configSmallPhotoControllerUI];
}
#pragma mark --
#pragma mark 初始化UI
-(void)configSmallPhotoControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomTitle:self.smallTitle];
    
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    _smallCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayOut];
    [self.view addSubview:_smallCollect];
    [_smallCollect registerNib:[UINib nibWithNibName:@"FZJSmallPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallPhotoCell"];
    _smallCollect.delegate = self;
    _smallCollect.dataSource = self;
    _smallCollect.backgroundColor = [UIColor whiteColor];
    
//    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    _FZJCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, _addBtn.origin.y + _addBtn.size.height + 10,SCREEN_WIDTH - 20, 100) collectionViewLayout:flowLayOut];
//    [self.view addSubview:_FZJCollection];
//    [_FZJCollection registerNib:[UINib nibWithNibName:@"FZJSmallPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallPhotoCell"];
//    _FZJCollection.showsHorizontalScrollIndicator = NO;
//    _FZJCollection.delegate = self;
//    _FZJCollection.dataSource = self;
//    _FZJCollection.backgroundColor = [UIColor whiteColor];
}
#pragma mark--
#pragma mark 数据请求

#pragma mark--
#pragma mark 数据加载

#pragma mark--
#pragma mark 事件
#pragma mark --- cell的照片选择事件
-(void)smallCellBtnClicked:(UIButtonExt *)btn{
    btn.selected = !btn.selected;
    NSLog(@"---%d",btn.selected);
    
}
#pragma mark--
#pragma mark  代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchResult.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FZJSmallPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallPhotoCell" forIndexPath:indexPath];
    CGSize size = cell.size;
    size.width *= 2;
    size.height *= 2;
    [[FZJPhotoTool defaultFZJPhotoTool] getImageByAsset:self.fetchResult[indexPath.row] makeSize:size makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *AssetImage) {
        cell.ImageView.image = AssetImage;
    }];
    cell.ChooseBtn.index = indexPath.row;
    [cell.ChooseBtn addTarget:self action:@selector(smallCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (iPHone6) {
        return CGSizeMake(87, 87);
    }else if (iPHone6Plus){
        return CGSizeMake(97, 97);
    }else{
        return CGSizeMake(100, 100);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 0, 5);//上左下右
    
}
// 单元格最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
// 单元格最小行距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"-------------%d",(int)indexPath.row);
}

#pragma mark--
#pragma mark 通知注册及销毁
@end
