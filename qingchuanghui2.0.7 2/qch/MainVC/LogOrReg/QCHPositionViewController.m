//
//  QCHPositionViewController.m
//  qch
//
//  Created by 青创汇 on 16/1/5.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHPositionViewController.h"
#import "PositionCell.h"


@interface QCHPositionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    UIImageView *bkgImageView;
    UIButton *backBtn;
    UIButton *completeBtn;
    NSString * str;

}

@property (nonatomic,strong) UICollectionView *myCollectionView;
//@property (strong,nonatomic) NSArray *DataArray;
@property (nonatomic,strong) NSMutableArray *positionlist;

@end

@implementation QCHPositionViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    if (_positionlist !=nil) {
        _positionlist=[[NSMutableArray alloc]init];
    }
    
    [self createBackgroundImage];
    [self createBackBtn];
    [self createFrame];
    
    [self getData];
}

-(void)createBackgroundImage{
    //高斯模糊
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurSize=2.0;
    UIImage *image = [UIImage imageNamed:@"denglu_bj2_img"];
    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
    
    bkgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bkgImageView setImage:blurredImage];
    [self.view addSubview:bkgImageView];
}

-(void)createBackBtn{
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15*PMBWIDTH, 18*PMBWIDTH, 24*PMBWIDTH, 24*PMBWIDTH);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(39*SCREEN_WSCALE, backBtn.top, SCREEN_WIDTH-39*2*PMBWIDTH, backBtn.height)];
    titleLabel.text=@"职位";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.font=Font(18);
    [self.view addSubview:titleLabel];
    
}

- (void)pop:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createFrame{
    
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //接下来就在创建collectionView的时候初始化，就很方便了（能直接带上layout）
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 62*PMBWIDTH, ScreenWidth, ScreenHeight-42*PMBWIDTH) collectionViewLayout:flowLayout];
    _myCollectionView.tag = 200;
    _myCollectionView.backgroundColor = [UIColor clearColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    //添加到主页面上去
    [self.view addSubview:_myCollectionView];
    
    //collection头视图的注册   奇葩的地方来了，头视图也得注册
    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Identifierhead"];
    
    
    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Identifierfoot"];
    
     [_myCollectionView registerNib:[UINib nibWithNibName:@"PositionCell" bundle:nil] forCellWithReuseIdentifier:@"positionCell"];
    
}

-(void)getData{
    //type=1职位
    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:1 complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _positionlist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _positionlist=[[NSMutableArray alloc]init];
        }
        [_myCollectionView reloadData];
    }];
}


#pragma mark -UICollectionViewDataSource
//指定组的个数 ，一个大组！！不是一排，是N多排组成的一个大组(与下面区分)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_positionlist count];
}

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array=[[_positionlist objectAtIndex:section] objectForKey:@"children"];
    return [array count];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Identifierfoot" forIndexPath:indexPath];
        UILabel *hengxianlab = [[UILabel alloc]initWithFrame:CGRectMake(20*PMBWIDTH, 20*PMBWIDTH, ScreenWidth-40*PMBWIDTH, 1*PMBWIDTH)];
        hengxianlab.backgroundColor = [UIColor lightGrayColor];
        [footerview addSubview:hengxianlab];
        reusableview = footerview;
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [[[_positionlist objectAtIndex:indexPath.section] objectForKey:@"children"]objectAtIndex:indexPath.row] ;

    PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
    
    cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
    [cell setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    cell.layer.cornerRadius = cell.height/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

//定义每个UICollectionViewCell 的大小*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80*PMBWIDTH, 30*PMBWIDTH);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={0,0};
    return size;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    CGSize size={ScreenWidth,30};
    return size;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10*PMBWIDTH;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor themeTextColorWithAlpha:1.0]];
    
    NSDictionary *dict = [[[_positionlist objectAtIndex:indexPath.section] objectForKey:@"children"]objectAtIndex:indexPath.row] ;
    
    if ([self.positonDelegate respondsToSelector:@selector(selectPosition:)]) {
        [self.positonDelegate selectPosition:dict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
