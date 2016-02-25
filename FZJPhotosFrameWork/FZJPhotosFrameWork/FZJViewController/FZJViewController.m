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
#import "FZJPhotoModel.h"
#import "FZJBigPhotoController.h"


@interface FZJViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextField *PhotoNumberText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property(nonatomic,strong)UICollectionView * FZJCollection;
/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray<FZJPhotoModel *> * dataArr;

/**
 *  最多能选择几张照片
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
    return _dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJSmallPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SmallPhotoCell" forIndexPath:indexPath];
    cell.ImageView.image = nil;
    cell.ChooseBtn.hidden = YES;
    cell.ImageView.layer.cornerRadius = 5;
    cell.ImageView.layer.masksToBounds = YES;
    FZJPhotoModel * model = _dataArr[indexPath.row];
    [[FZJPhotoTool defaultFZJPhotoTool] getImageByAsset:model.asset makeSize:CGSizeMake(90, 90) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *AssetImage) {
        cell.ImageView.image = AssetImage;
    }];
    
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
 *  点中事件  进入大图浏览
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJBigPhotoController * bigPhoto = [[FZJBigPhotoController alloc]init];
    bigPhoto.clickNum = indexPath.row;
    NSMutableArray * fetchResult = [NSMutableArray array];
    for (FZJPhotoModel * moel in _dataArr) {
        [fetchResult addObject:moel.asset];
    }
    bigPhoto.fetchResult = (NSArray *)fetchResult;
    bigPhoto.ChooseArr = [NSMutableArray arrayWithArray:_dataArr];
    bigPhoto.chooseState = YES;
    bigPhoto.addNum = self.MaxNumber;
    [bigPhoto returnToRoot:^(id data) {
        _dataArr = [NSMutableArray arrayWithArray:data];
        [_FZJCollection reloadData];
    }];
    [self.navigationController pushViewController:bigPhoto animated:YES];

}

/**
 *  添加照片的按钮点击事件 获得最多能添加的照片
 *
 */
- (IBAction)addPhoto:(id)sender {
    
    if (_PhotoNumberText.text.length) {
        self.MaxNumber = [_PhotoNumberText.text integerValue];
    }else{
         self.MaxNumber = 10;
    }
    NSLog(@"%d",(int)self.MaxNumber);
    /**
     *  每次点击添加按钮进行判断照片数量是否达到上限
     */
    
    if (_dataArr.count > self.MaxNumber) {
        
        /**
         *  跳转提示窗口
         */
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多选择%d张",self.MaxNumber]];
        
    }else{
        
         [self popChooseActionView];
        
    }
   
}
/**
 *  选择照片的弹出窗口
 */
-(void)popChooseActionView{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction * ablum = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self FZJhaveAlbumAuthority]) {
            
            FZJenterAlbumController * enter = [self.storyboard instantiateViewControllerWithIdentifier:@"enterAlbum"];
            enter.photoList = [[FZJPhotoTool defaultFZJPhotoTool] getAllPhotoList];
            enter.addNum = self.MaxNumber - _dataArr.count;
            
            [enter enterAlbum:^(id data) {
                [_dataArr addObjectsFromArray:data];
                [self.FZJCollection reloadData];
            }];
            
            [self.navigationController pushViewController:enter animated:YES];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相册\"中允许访问相册"];
            
        }
        
        
        NSLog(@"从相册取照片");
        
    }];
    UIAlertAction * take = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([self FZJhaveCameraAuthority]) {
            [self takePhotoFromiPhone];
        }else{
           [SVProgressHUD showErrorWithStatus:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
        }
        NSLog(@"拍照");
        
    }];
    [alert addAction:ablum];
    [alert addAction:take];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --  照相 
-(void)takePhotoFromiPhone{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"该设备没有摄像头");
    }
}
#pragma mark -- 照相的代理的方法
/**
 *  写入相册
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  写入相册后的方法
 */
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (!error) {
        PHAsset * asset = [[[FZJPhotoTool defaultFZJPhotoTool] getAllAssetInPhotoAblumWithAscending:YES] lastObject];
        FZJPhotoModel * model = [[FZJPhotoModel alloc]init];
        model.asset = asset;
        model.imageName = [asset valueForKey:@"filename"];
        [_dataArr addObject:model];
        [self.FZJCollection reloadData];
    }
}
#pragma mark --  判断对相册和相机的使用权限
/**
 *  相册的使用权限
 *
 *  @return 是否
 */
-(BOOL)FZJhaveAlbumAuthority{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
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
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
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
