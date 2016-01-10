//
//  FZJViewController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJViewController.h"
#import "FZJSmallPhotoCell.h"
#import "FZJenterAlbumController.h"

@interface FZJViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextField *PhotoNumberText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic,strong)UICollectionView * FZJCollection;
/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray * dataArr;

/**
 *  最多能选择多少张照片
 */
@property(nonatomic,assign)NSInteger MaxNumber;


@end

@implementation FZJViewController
-(void)viewDidLoad{
    /**
     *  用collectionView来展示图片 小图展示
     */
    [self addCollectonViewToShowPhoto];
}

-(void)addCollectonViewToShowPhoto{
    
    
    _dataArr = [NSMutableArray array];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    [flowLayOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _FZJCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, _addBtn.origin.y + _addBtn.size.height + 10,SCREEN_WIDTH - 20, 100) collectionViewLayout:flowLayOut];
    [self.view addSubview:_FZJCollection];
    [_FZJCollection registerNib:[UINib nibWithNibName:@"FZJSmallPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"SmallPhotoCell"];
    _FZJCollection.showsHorizontalScrollIndicator = NO;
    _FZJCollection.delegate = self;
    _FZJCollection.dataSource = self;
    _FZJCollection.backgroundColor = [UIColor whiteColor];
    
}
#pragma mark--
#pragma mark  ---   代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJSmallPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallPhotoCell" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}
/**
 *  上下左右的间隔
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);//上左下右
    
}
/**
 *  单元格的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 90);
}
/**
 *  单元格最小间距
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
/**
 *  单元格最小行距
 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
/**
 *  点中事件
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"-------------%d",(int)indexPath.row);
}

/**
 *  添加照片的按钮点击事件 获得最多能添加的照片
 *
 */
- (IBAction)addPhoto:(id)sender {
    
    if (_PhotoNumberText.text.length) {
        self.MaxNumber = [_PhotoNumberText.text intValue];
    }else{
         self.MaxNumber = 10;
    }
    [self popChooseActionView];
}
/**
 *  选择照片的弹出窗口
 */
-(void)popChooseActionView{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction * ablum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self FZJhaveAlbumAuthority]) {
            
            
           // UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"FZJViewController" bundle:nil];
            
            FZJenterAlbumController * enter = [self.storyboard instantiateViewControllerWithIdentifier:@"enterAlbum"];
            [self.navigationController pushViewController:enter animated:YES];
            
            
        }else{
            
        }
        
        
        NSLog(@"从相册取照片");
        
    }];
    UIAlertAction * take = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self FZJhaveCameraAuthority]) {
            
        }else{
            
        }
        
        
        NSLog(@"拍照");
        
    }];
    [alert addAction:ablum];
    [alert addAction:take];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark --  判断对相册和相机的使用权限
/**
 *  相册的使用权限
 *
 *  @return 是否
 */
-(BOOL)FZJhaveAlbumAuthority{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
    
}
/**
 *  相机的使用权限
 *
 *  @return 是否
 */
-(BOOL)FZJhaveCameraAuthority{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}






/**
 *  键盘收缩
 *
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_PhotoNumberText resignFirstResponder];
}
@end
