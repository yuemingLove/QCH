//
//  ProductsVC.m
//  qch
//
//  Created by 青创汇 on 16/4/28.
//  Copyright © 2016年 qch. All rights rieserved.
//

#import "ProductsVC.h"
#import "HambitusCell.h"
#import "TZImagePickerController.h"
#import "ProjectLinkView.h"
#import "SendProjectFourVC.h"
// 引入FMDB头文件进行项目数据持久化
#import "FMDBHelper.h"
#import "ProjectModel.h"

#define kImage(num) [NSString stringWithFormat:@"%@%d", model.pro_productImage, num]

@interface ProductsVC ()<UICollectionViewDataSource,UICollectionViewDelegate,HambitusCellDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,ProjectLinkViewDelegate,CommitAlertViewDelegate>{
    CGFloat _margin;
    CGFloat _itemWH;
    UICollectionView *_collectionView;
    UILabel *countlab;
    UILabel *RemindLab;
    NSMutableArray *_selectedPhotos;
    NSMutableString *photoStr;
    NSInteger type;
    NSString *website;
    NSString *link;
    NSString *weixin;
    ProjectLinkView *footerview;
}


@end

@implementation ProductsVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 查询本地数据库中数据并展示
    [self selectFromDataBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品展示";
    photoStr=[@"" mutableCopy];
    website = @"";
    link = @"";
    weixin = @"";
     _selectedPhotos = [NSMutableArray array];
    [self creatmainview];
    [self configCollectionView];
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;

}

- (void)creatmainview
{
    UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 15*PMBWIDTH, ScreenWidth-10*PMBWIDTH, 15*PMBWIDTH)];
    titlelab.textColor = [UIColor blackColor];
    titlelab.text = @"产品展示";
    titlelab.font = Font(15);
    [self.view addSubview:titlelab];
    
    UILabel *infomationlab = [[UILabel alloc]initWithFrame:CGRectMake(titlelab.left, titlelab.bottom+10*PMBWIDTH, titlelab.width, 26*PMBWIDTH)];
    infomationlab.text = @"可上传您的app下载二维码、网站页面、APP界面、产品介绍PPT，让投资人更直观认识您的产品";
    infomationlab.numberOfLines = 0;
    infomationlab.textColor = [UIColor lightGrayColor];
    infomationlab.font = Font(13);
    [self.view addSubview:infomationlab];
    
    countlab = [[UILabel alloc]initWithFrame:CGRectMake(titlelab.left, infomationlab.bottom+10*PMBWIDTH, titlelab.width, titlelab.height)];
    countlab.text = @"最多支持9张图";
    countlab.textColor = [UIColor lightGrayColor];
    countlab.font = Font(14);
    [self.view addSubview:countlab];
    
}

- (void)configCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4*PMBWIDTH;
    _itemWH = (self.view.width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, countlab.bottom+10*PMBWIDTH, self.view.width - 2 * _margin, 420*PMBWIDTH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HambitusCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_collectionView registerClass:[ProjectLinkView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ProjectLinkView"];
    
    RemindLab = [[UILabel alloc]initWithFrame:CGRectMake(145*PMBWIDTH, 145*PMBWIDTH, 60*PMBWIDTH, 15*PMBWIDTH)];
    RemindLab.text = @"添加照片";
    RemindLab.font = Font(15);
    RemindLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:RemindLab];
    
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count < 9) {
        return _selectedPhotos.count + 1;
    }else if (_selectedPhotos.count >= 9){
        return 9;
    }
    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        footerview =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ProjectLinkView" forIndexPath:indexPath];
        reusableview = footerview;
        footerview.linkdelegate = self;
        [footerview.nextbtn addTarget:self action:@selector(addteam:) forControlEvents:UIControlEventTouchUpInside];
    }
    return reusableview;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size={ScreenWidth,220*PMBWIDTH};
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HambitusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.deleteBtn.hidden = YES;
    cell.hmdelegate = self;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"dongtai_tjzp_btn"];
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
    }
    [cell.deleteBtn addTarget:self action:@selector(deleteClickAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag=indexPath.row;
    if (_selectedPhotos.count > 0) {
        RemindLab.hidden = YES;
    }else{
        RemindLab.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedPhotos.count >=9) {
        
        [SVProgressHUD showErrorWithStatus:@"限制上传9张图片" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        if (indexPath.row == _selectedPhotos.count) [self pickPhotoButtonClick:nil];
    }
    
}

- (void)pickPhotoButtonClick:(UIButton *)sender
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)longtapImagewithObject:(HambitusCell *)cell longtap:(UILongPressGestureRecognizer *)longtap
{
    cell.deleteBtn.hidden = NO;
}

//删除
- (void)deleteClickAction:(UIButton *)sender{
    
    NSInteger index=[sender tag];
    [_selectedPhotos removeObjectAtIndex:index];
    NSArray *imageArray=[photoStr componentsSeparatedByString:@","];
    NSString *imageStr=@"";
    for (int i=0; i<[imageArray count]; i++) {
        if (index!=i) {
            NSString *imageurl=imageArray[i];
            if ([self isBlankString:imageStr]) {
                imageStr=imageurl;
            }else{
                imageStr =[imageStr stringByAppendingString:[NSString stringWithFormat:@",%@",imageurl]];
            }
        }
    }
    photoStr=[imageStr mutableCopy];
    [_collectionView reloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
//mark
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_selectedPhotos addObjectsFromArray:photos];
        [_collectionView reloadData];
        _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    });
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos{
    
    for (UIImage *image in photos) {
        NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
        NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
        if ([self isBlankString:photoStr]) {
            photoStr = [imageStr mutableCopy];
        }else{
            [photoStr appendFormat:@",%@", imageStr];
        }
    }
    // 此处如果用户上传总图片数大于9张, 只取前9张数据上传服务器
    NSArray *imageArray=[photoStr componentsSeparatedByString:@","];
    NSString *imageSt=@"";
    for (int i=0; i<[imageArray count]; i++) {
        if (i < 9) {
            NSString *imageurl=imageArray[i];
            if ([self isBlankString:imageSt]) {
                imageSt=imageurl;
            }else{
                imageSt =[imageSt stringByAppendingString:[NSString stringWithFormat:@",%@",imageurl]];
            }
        }
    }
    photoStr=[imageSt mutableCopy];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
    NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
    if ([self isBlankString:photoStr]) {
        photoStr=[imageStr mutableCopy];
    }else{
        [photoStr appendFormat:@",%@", imageStr];
    }
    // 此处如果用户上传总图片数大于9张, 只取前9张数据上传服务器
    NSArray *imageArray=[photoStr componentsSeparatedByString:@","];
    NSString *imageSt=@"";
    for (int i=0; i<[imageArray count]; i++) {
        if (i < 9) {
            NSString *imageurl=imageArray[i];
            if ([self isBlankString:imageSt]) {
                imageSt=imageurl;
            }else{
                imageSt =[imageSt stringByAppendingString:[NSString stringWithFormat:@",%@",imageurl]];
            }
        }
    }
    photoStr=[imageSt mutableCopy];
    
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}

//点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectClicked:(UIButton *)sender index:(NSInteger)index
{
    if (index==0) {
        type=0;
        CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"请编辑官网链接" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textViewPlaceholder:website];
        commit.delegate = self;
        if ([self isBlankString:website]) {
            commit.placeholder.text = @"http://www.cn-qch.com";
        } else {
            commit.placeholder.hidden = YES;
        }
        [self.view addSubview:commit];
    }else if (index==1){
        type=1;
        CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"请编辑客户端链接" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textViewPlaceholder:link];
        commit.delegate = self;
        if ([self isBlankString:link]) {
            commit.placeholder.text = @"http://www.cn-qch.com";
        } else {
            commit.placeholder.hidden = YES;
        }
        [self.view addSubview:commit];

    }else if (index==2){
        type=2;
        CommitAlertView *commit=[[CommitAlertView alloc]initWithView:@"请编辑微信公众号" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" textViewPlaceholder:weixin];
        commit.delegate = self;
        commit.placeholder.hidden=YES;
        [self.view addSubview:commit];
    }
}
// mark
-(void)updateTextViewData:(NSString *)text{
    if (type==0) {
        // 判断用户输入格式是否正确
        if (text.length > 5) {
            if ([[text substringToIndex:4] isEqualToString:@"HTTP"] || [[text substringToIndex:4] isEqualToString:@"http"]|| [[text substringToIndex:4] isEqualToString:@"Http"]|| [[text substringToIndex:4] isEqualToString:@"HTtp"]|| [[text substringToIndex:4] isEqualToString:@"HTTp"]) {
                website = text;
                if (footerview.button1Block) {
                    footerview.button1Block();
                }
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请检查链接格式" message:@"例如: http://www.cn-qch.com" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }

        }
    }else if (type==1){
        // 判断用户输入格式是否正确
        if (text.length > 5) {
            if ([[text substringToIndex:4] isEqualToString:@"HTTP"] || [[text substringToIndex:4] isEqualToString:@"http"]|| [[text substringToIndex:4] isEqualToString:@"Http"]|| [[text substringToIndex:4] isEqualToString:@"HTtp"]|| [[text substringToIndex:4] isEqualToString:@"HTTp"]) {
                link = text;
                if (footerview.button2Block) {
                    footerview.button2Block();
                }
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请检查链接格式" message:@"例如: http://www.cn-qch.com" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }

        }
    }else if (type==2){
        weixin = text;
        if (footerview.button3Block) {
            footerview.button3Block();
        }
    }
}
- (void)addteam:(UIButton*)sender
{
    [_addprojectdic setObject:photoStr forKey:@"pic"];
    [_addprojectdic setObject:website forKey:@"website"];
    [_addprojectdic setObject:link forKey:@"link"];
    [_addprojectdic setObject:weixin forKey:@"weixin"];
    // 保存到数据库
    [self insertIntoDataBase];
    SendProjectFourVC *sendproject = [[SendProjectFourVC alloc]init];
    sendproject.Addprojectdic = _addprojectdic;
    [self.navigationController pushViewController:sendproject animated:YES];
}
- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
#pragma mark - dataBase
// 插入到数据库
- (void)insertIntoDataBase {
    //------------持久化到数据库
    [FMDBHelper shareFMDBHelper].singleProjectImageModel.pro_photoStr = photoStr;
    [FMDBHelper shareFMDBHelper].singleProjectImageModel.pro_websiteLink = website;
    [FMDBHelper shareFMDBHelper].singleProjectImageModel.pro_weixinLink = weixin;
    [FMDBHelper shareFMDBHelper].singleProjectImageModel.pro_linkLink = link;
    ProjectModel *model = [[ProjectModel alloc] init];
    model = [FMDBHelper shareFMDBHelper].singleProjectImageModel;
    //    for (int i = 1; i < _selectedPhotos.count + 1; i++) {
    //        UIImage *image = kImage(i);
    //         = [_selectedPhotos objectAtIndex:i];
    //    }
    switch (_selectedPhotos.count) {
        case 0:
        {
            model.pro_productImage1 = nil; model.pro_productImage2 = nil; model.pro_productImage3 = nil;
            model.pro_productImage4 = nil; model.pro_productImage5 = nil; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 1:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = nil; model.pro_productImage3 = nil;
            model.pro_productImage4 = nil; model.pro_productImage5 = nil; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 2:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = nil;
            model.pro_productImage4 = nil; model.pro_productImage5 = nil; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 3:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = nil; model.pro_productImage5 = nil; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 4:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = nil; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 5:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = nil;
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 6:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = _selectedPhotos[5];
            model.pro_productImage7 = nil; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 7:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = _selectedPhotos[5];
            model.pro_productImage7 = _selectedPhotos[6]; model.pro_productImage8 = nil; model.pro_productImage9 = nil;
        }
            break;
        case 8:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = _selectedPhotos[5];
            model.pro_productImage7 = _selectedPhotos[6]; model.pro_productImage8 = _selectedPhotos[7]; model.pro_productImage9 = nil;
        }
            break;
        case 9:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = _selectedPhotos[5];
            model.pro_productImage7 = _selectedPhotos[6]; model.pro_productImage8 = _selectedPhotos[7]; model.pro_productImage9 = _selectedPhotos[8];
        }
            break;
        default:
        {
            model.pro_productImage1 = _selectedPhotos[0]; model.pro_productImage2 = _selectedPhotos[1]; model.pro_productImage3 = _selectedPhotos[2];
            model.pro_productImage4 = _selectedPhotos[3]; model.pro_productImage5 = _selectedPhotos[4]; model.pro_productImage6 = _selectedPhotos[5];
            model.pro_productImage7 = _selectedPhotos[6]; model.pro_productImage8 = _selectedPhotos[7]; model.pro_productImage9 = _selectedPhotos[8];
        }
            break;
    }
    [FMDBHelper shareFMDBHelper].singleProjectImageModel = model;
    // 不存在创建数据库
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"proImage_id"];
        [FMDBHelper shareFMDBHelper].singleProjectImageModel.pro_id = @"1";
        
        [[FMDBHelper shareFMDBHelper] insertProjectImageWithProject:[FMDBHelper shareFMDBHelper].singleProjectImageModel];
    } else {
        // 已经创建执行更新数据库
        [[FMDBHelper shareFMDBHelper] updateProjectImageSetProject:[FMDBHelper shareFMDBHelper].singleProjectImageModel withPro_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]];
    }
 
}
// 从数据库中查询
- (void)selectFromDataBase {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]) {
        ProjectModel *model = [[FMDBHelper shareFMDBHelper] searchProjectImageWithPro_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"proImage_id"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![self isBlankString:model.pro_websiteLink]) {
                website = model.pro_websiteLink;
                if (footerview.button1Block) {
                    footerview.button1Block();
                }
            } else {
                website = @"";
            }
            if (![self isBlankString:model.pro_linkLink]) {
                link = model.pro_linkLink;
                if (footerview.button2Block) {
                    footerview.button2Block();
                }
                
            } else {
                link = @"";
            }
            if (![self isBlankString:model.pro_weixinLink]) {
                weixin = model.pro_weixinLink;
                if (footerview.button3Block) {
                    footerview.button3Block();
                }
            } else {
                weixin = @"";
            }
        });
        if (![self isBlankString:model.pro_photoStr]) {
            photoStr = [model.pro_photoStr mutableCopy];
        } else {
            photoStr = [@"" mutableCopy];
        }
        //        for (int i = 1; i < 10; i++) {
        //            //NSLog(@"%@", kImage(i));
        //            if (kImage(i)) {
        //                [_selectedPhotos addObject:kImage(i)];
        //            }
        //        }
        [_selectedPhotos removeAllObjects];
        if (model.pro_productImage1) {
            [_selectedPhotos addObject:model.pro_productImage1];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage2) {
            [_selectedPhotos addObject:model.pro_productImage2];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage3) {
            [_selectedPhotos addObject:model.pro_productImage3];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage4) {
            [_selectedPhotos addObject:model.pro_productImage4];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage5) {
            [_selectedPhotos addObject:model.pro_productImage5];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage6) {
            [_selectedPhotos addObject:model.pro_productImage6];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage7) {
            [_selectedPhotos addObject:model.pro_productImage7];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage8) {
            [_selectedPhotos addObject:model.pro_productImage8];
            [_collectionView reloadData];
        } else {
            return;
        }
        if (model.pro_productImage9) {
            [_selectedPhotos addObject:model.pro_productImage9];
            [_collectionView reloadData];
        } else {
            return;
        }
    }
 
}
#pragma mark - backAction
- (void)backAction {
    // 持久化到数据库
    [self insertIntoDataBase];
    [self.navigationController popViewControllerAnimated:YES];

}


@end
