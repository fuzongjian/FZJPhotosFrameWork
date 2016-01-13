//
//  FZJenterAlbumController.m
//  FZJPhotosFrameWork
//
//  Created by fdkj0002 on 16/1/10.
//  Copyright © 2016年 fdkj0002. All rights reserved.
//

#import "FZJenterAlbumController.h"
#import "FZJenterAlbumCell.h"
#import "FZJSmallPhotoController.h"

@interface FZJenterAlbumController ()

@end

@implementation FZJenterAlbumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configEnterAlbumControllerUI];
    
}


-(void)configEnterAlbumControllerUI{
    /**
     *   标题
     */
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"相册";
    title.font = [UIFont systemFontOfSize:15];
    self.navigationItem.titleView = title;
    
    /**
     *  返回按钮
     */
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    back.frame = CGRectMake(0, 0, 44, 44);
    [back addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    /**
     *  表格注册
     */
    [self.tableView registerNib:[UINib nibWithNibName:@"FZJenterAlbumCell" bundle:nil] forCellReuseIdentifier:@"enterCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _photoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZJenterAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enterCell" forIndexPath:indexPath];
    
    FZJPhotoList * list = _photoList[indexPath.row];
    
    [[FZJPhotoTool defaultFZJPhotoTool] getImageByAsset:list.firstAsset makeSize:CGSizeMake(80, 80) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *AssetImage) {
        if (AssetImage) {
            cell.iconImageView.image = AssetImage;
        }
    }];
    cell.albumName.text = list.title;
    cell.albumNumber.text = [NSString stringWithFormat:@"%d",(int)list.photoNum];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FZJSmallPhotoController * smallPhoto = [[FZJSmallPhotoController alloc]init];
    FZJPhotoList * list = _photoList[indexPath.row];
    smallPhoto.smallTitle = list.title;
    smallPhoto.addNum = self.addNum;
    smallPhoto.returnBlock = self.returnBlock;
    smallPhoto.fetchResult = [[FZJPhotoTool defaultFZJPhotoTool] getAssetsInAssetCollection:list.assetCollection ascending:YES];
    [self.navigationController pushViewController:smallPhoto animated:YES];
    
    
}
#pragma mark --- 返回按钮点击事件
-(void)backBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)enterAlbum:(returnBackPhotoArr)block{
    self.returnBlock = block;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
