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
#import "FZJBigPhotoController.h"
@interface FZJSmallPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 *  创建collectionView用于展示
 */
@property(nonatomic,strong)UICollectionView * smallCollect;
/**
 *  存放已经选择的照片
 */
@property(nonatomic,strong)NSMutableArray * selectedPhoto;
/**
 *  展示当前选择照片的动态
 */
@property(nonatomic,strong)UILabel * middle;

@end
@implementation FZJSmallPhotoController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self configSmallPhotoControllerUI];
    [self showSelectedStatusUI];
}
#pragma mark --
#pragma mark 初始化UI
-(void)configSmallPhotoControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCustomTitle:self.smallTitle];
    _selectedPhoto = [NSMutableArray array];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
    _smallCollect = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayOut];
    [self.view addSubview:_smallCollect];
    [_smallCollect registerNib:[UINib nibWithNibName:@"FZJSmallPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallPhotoCell"];
    _smallCollect.delegate = self;
    _smallCollect.dataSource = self;
    _smallCollect.backgroundColor = [UIColor whiteColor];
    
}
-(void)showSelectedStatusUI{
    UIView * showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:showView];
    
    UILabel * middle = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 0.3, 0, SCREEN_WIDTH * 0.4, 30)];
    middle.textAlignment = NSTextAlignmentCenter;
    middle.text = [NSString stringWithFormat:@"%d/%d",0,(int)self.addNum];
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
-(void)sureBtnClickBackToRoot{
    
    if (self.returnBlock && self.selectedPhoto.count) {
        self.returnBlock(self.selectedPhoto);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark --- cell的照片选择事件
-(void)smallCellBtnClicked:(UIButtonExt *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {//为1 则直接加进数组
        if (_selectedPhoto.count == self.addNum) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"本次最多选择%d张",(int)self.addNum]];
            btn.selected = NO;
        }else{
            FZJPhotoModel * model = [[FZJPhotoModel alloc]init];
            model.asset = _fetchResult[btn.index];
            model.imageName = [_fetchResult[btn.index] valueForKey:@"filename"];
            [_selectedPhoto addObject:model];
        }
    }else{//为0 从数组中删除
        for (FZJPhotoModel * model in _selectedPhoto) {
            if ([model.imageName isEqualToString:[_fetchResult[btn.index] valueForKey:@"filename"]]) {
                [_selectedPhoto removeObject:model];
            }
        }
    }
    _middle.text = [NSString stringWithFormat:@"%d/%d",(int)self.selectedPhoto.count,(int)self.addNum];
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
    size.width *= [UIScreen mainScreen].scale;
    size.height *= [UIScreen mainScreen].scale;
    [[FZJPhotoTool defaultFZJPhotoTool] getImageByAsset:self.fetchResult[indexPath.row] makeSize:size makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *AssetImage) {
        cell.ImageView.image = AssetImage;
    }];
    cell.ChooseBtn.index = indexPath.row;
    cell.ChooseBtn.selected = NO;
    [cell.ChooseBtn addTarget:self action:@selector(smallCellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    for (FZJPhotoModel * model  in _selectedPhoto) {
        if ([model.imageName isEqualToString:[_fetchResult[indexPath.row] valueForKey:@"filename"]]) {
            cell.ChooseBtn.selected = YES;
        }
    }
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
    
    
    FZJBigPhotoController * bigPhoto = [[FZJBigPhotoController alloc]init];
    bigPhoto.fetchResult = self.fetchResult;
    bigPhoto.addNum = self.addNum;
    bigPhoto.ChooseArr = self.selectedPhoto;
    bigPhoto.clickNum = indexPath.row;
    bigPhoto.returnBlock = self.returnBlock;
    
    __weak __typeof(self) weakSelf = self;
    __block __typeof (_selectedPhoto) weakSelectedPhoto = _selectedPhoto;
    __block __typeof (_middle)weakMiddle = _middle;
    
    [bigPhoto returnBack:^(id data) {
        weakSelectedPhoto = [NSMutableArray arrayWithArray:data];
        weakMiddle.text = [NSString stringWithFormat:@"%d/%d",(int)self.selectedPhoto.count,(int)self.addNum];
        [weakSelf.smallCollect reloadData];
    }];
    
    
    [self.navigationController pushViewController:bigPhoto animated:YES];

}

#pragma mark--
#pragma mark 通知注册及销毁
@end
