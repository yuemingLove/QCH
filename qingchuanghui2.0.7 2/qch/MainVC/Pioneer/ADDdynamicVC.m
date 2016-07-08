//
//  ADDdynamicVC.m
//  qch
//
//  Created by 青创汇 on 16/1/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ADDdynamicVC.h"
#import "QCHNavigationController.h"
#import "HttpDynamicAction.h"
#import "HambitusCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "QCHambitusVC.h"
#import "FooterView.h"
@interface ADDdynamicVC ()<UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,HambitusCellDelegate>
{
    
    UIButton *locationBtn;
    NSMutableDictionary *Dic;
    UICollectionView *_collectionView;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSString *phoneImage;
    NSString *CameraImage;
    CGFloat _itemWH;
    CGFloat _margin;
    NSString *Locationstr;
    UILabel *RemindLab;
    UIBarButtonItem *rightitem;
    
    NSString *photoStr;
}

@property (nonatomic, strong) UITextView *realTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;




@end

@implementation ADDdynamicVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布动态";
    [self createMainView];
    
    photoStr=@"";
    Locationstr=@"";
    //设置导航条两边按钮
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancle)];
    [self.navigationItem setLeftBarButtonItem:leftitem];
    
    rightitem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sure)];
    [self.navigationItem setRightBarButtonItem:rightitem];
    if (!Dic) {
        Dic = [NSMutableDictionary new];
    }
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    [self configCollectionView];
    rightitem.enabled = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_realTextView resignFirstResponder];
}



- (void)createMainView

{
    NSTextStorage *textStorage = [[NSTextStorage alloc]init];
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.view.frame.size.width, 120*PMBWIDTH)];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [textStorage addLayoutManager:layoutManager];
    self.realTextView = [[UITextView alloc] initWithFrame:CGRectMake(5*PMBWIDTH, 0, ScreenWidth-10*PMBWIDTH, 120*PMBWIDTH) textContainer:container];
    [self.realTextView setFont:Font(15)];
    [self.view addSubview:self.realTextView];
    [self.realTextView becomeFirstResponder];
    self.realTextView.editable = YES;
    self.realTextView.delegate = self;
    self.realTextView.userInteractionEnabled = YES;
    
    //添加站位语句
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5*PMBWIDTH, -4.5*PMBWIDTH,100*PMBWIDTH, 40*PMBWIDTH)];
    self.placeholderLabel.text = @"聊点儿创业事儿....";
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.font = Font(14);
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    [self.realTextView addSubview:self.placeholderLabel];
    
    
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 4*PMBWIDTH;
    _itemWH = (self.view.width - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_margin, self.realTextView.bottom+10*PMBWIDTH, self.view.width - 2 * _margin, 340*PMBWIDTH) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 0, 2);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HambitusCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Identifierfoot"];
    
    RemindLab = [[UILabel alloc]initWithFrame:CGRectMake(145*PMBWIDTH, 188*PMBWIDTH, 60*PMBWIDTH, 15*PMBWIDTH)];
    RemindLab.text = @"添加照片";
    RemindLab.font = Font(15);
    RemindLab.textColor = [UIColor lightGrayColor];
    [self.view addSubview:RemindLab];
    
    
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count<9) {
        return _selectedPhotos.count + 1;
    }else if (_selectedPhotos.count >= 9){
        return 9;
    }
    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        FooterView *footerview =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierfoot" forIndexPath:indexPath];
        [footerview.locationBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
        reusableview = footerview;
    }
    return reusableview;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size={ScreenWidth,40*PMBWIDTH};
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
        rightitem.enabled = YES;
        RemindLab.hidden = YES;
    }else{
        rightitem.enabled = NO;
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
    photoStr=imageStr;
    [_collectionView reloadData];
}

#pragma mark TZImagePickerControllerDelegate



/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    [_selectedPhotos addObjectsFromArray:photos];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}



#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    [self showPlaceHolderLabelWithTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }
    
}

- (void)showPlaceHolderLabelWithTextView:(UITextView *)textView{
    if (textView.text.length > 0 && ![@" " isEqualToString:textView.text]) {
        self.placeholderLabel.hidden = YES;
        rightitem.enabled = YES;
    }else{
        self.placeholderLabel.hidden = NO;
        rightitem.enabled = NO;
    }
}
- (void)cancle{
    if ([self.navigationController isKindOfClass:[QCHNavigationController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)sure{
    // 去除首位空格和换行
    self.realTextView.text = [self.realTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([self isBlankString:self.realTextView.text] && [_selectedPhotos count]==0 ) {
        return;
    }
    [SVProgressHUD showWithStatus:@"发布动态" maskType:SVProgressHUDMaskTypeBlack];
    
    [Dic setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [Dic setObject:self.realTextView.text forKey:@"contents"];
    [Dic setObject:UserDefaultEntity.city forKey:@"city"];
    [Dic setObject:[NSString stringWithFormat:@"%f",UserDefaultEntity.longitude] forKey:@"longitude"];
    [Dic setObject:[NSString stringWithFormat:@"%f",UserDefaultEntity.latitude] forKey:@"latitude"];
    [Dic setObject:Locationstr forKey:@"address"];
    [Dic setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
    [Dic setObject:photoStr forKey:@"associatepic"];
    NSDictionary *postdic = [[NSDictionary alloc]initWithDictionary:Dic];
    [HttpDynamicAction publishdynamic:postdic complete:^(id result, NSError *error) {
        if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"dyRefleshing" forKey:@"dyRefleshing"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"发布成功" maskType:SVProgressHUDMaskTypeBlack];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"发布失败，请重新发布" maskType:SVProgressHUDMaskTypeBlack];
        }
    }];
}

- (void)location:(UIButton *)sender{
    
    QCHambitusVC *hambitus = [[QCHambitusVC alloc]init];
    [self.navigationController pushViewController:hambitus animated:YES];
    hambitus.hidesBottomBarWhenPushed = YES;
    [hambitus returnText:^(NSString *showText) {
        Locationstr = showText;
        [sender setTitle:showText forState:UIControlStateNormal];
        CGSize location = [showText sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f*PMBWIDTH],NSFontAttributeName,nil]];
        sender.width = location.width+20*PMBWIDTH;
        sender.titleLabel.width = location.width+20*PMBWIDTH;
    }];
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
            photoStr=imageStr;
        }else{
            photoStr=[photoStr stringByAppendingFormat:@",%@", imageStr];
        }
    }
    // 此处如果用户上传总图片数大于9张, 只取前9张数据上传服务器
    NSArray *imageArray=[photoStr componentsSeparatedByString:@","];
    NSString *imageStr=@"";
    for (int i=0; i<[imageArray count]; i++) {
        if (i < 9) {
            NSString *imageurl=imageArray[i];
            if ([self isBlankString:imageStr]) {
                imageStr=imageurl;
            }else{
                imageStr =[imageStr stringByAppendingString:[NSString stringWithFormat:@",%@",imageurl]];
            }
        }
    }
    photoStr=imageStr;
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
        photoStr=imageStr;
    }else{
        photoStr=[photoStr stringByAppendingFormat:@",%@", imageStr];
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
    photoStr=imageSt;
    
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

@end
