//
//  BestAddDomainVC.m
//  
//
//  Created by 青创汇 on 16/2/22.
//
//

#import "BestAndDomainVC.h"
#import "PositionCell.h"
@interface BestAndDomainVC ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UIImageView *bkgImageView;
    UIButton *backBtn;
    NSMutableArray *DataArray;
    UIButton *SaveBtn;

}
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,strong) NSMutableArray *positionlist;
@property (nonatomic, assign)NSInteger myRow;
@end

@implementation BestAndDomainVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createFrame];
    [self getData];
    if (_positionlist !=nil) {
        _positionlist=[[NSMutableArray alloc]init];
    }
    if (!DataArray) {
        DataArray = [[NSMutableArray alloc]init];
    }
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(sure:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    if (_Byid==81) {
        self.title = @"我最擅长";
    }else if (_Byid==80 ){
        self.title = @"关注领域";
    }else if (_Byid==94){
        self.title = @"投资领域";
    }else if (_Byid==95){
        self.title = @"投资阶段";
    }else if (_Byid==1362){
        self.title = @"创业意向";
    }else if (_Byid==1361){
        self.title = @"现阶段需求";
    }
    _myRow = 1000;
}

-(void)createFrame{
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //接下来就在创建collectionView的时候初始化，就很方便了（能直接带上layout）
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-42*PMBWIDTH) collectionViewLayout:flowLayout];
    _myCollectionView.tag = 200;
    _myCollectionView.backgroundColor = [UIColor clearColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    if (_Byid==1362) {
        _myCollectionView.allowsMultipleSelection=NO;
    } else {
    _myCollectionView.allowsMultipleSelection=YES;
    }
    //添加到主页面上去
    [self.view addSubview:_myCollectionView];
    
    //collection头视图的注册   奇葩的地方来了，头视图也得注册
    [_myCollectionView registerNib:[UINib nibWithNibName:@"PositionCell" bundle:nil] forCellWithReuseIdentifier:@"positionCell"];
    
}

- (void)sure:(UIBarButtonItem *)sender
{
    if (self.returnArrayblock !=nil) {
        Liu_DBG(@"%@", DataArray);
        self.returnArrayblock(DataArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnArray:(ReturnArrayBlock)block{
    self.returnArrayblock = block;
}
- (void)getData{
    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:_Byid complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _positionlist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _positionlist=[[NSMutableArray alloc]init];
        }
        [_myCollectionView reloadData];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_positionlist count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
    PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
    cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
    cell.nameLabel.textColor = [UIColor blackColor];
    [cell setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    cell.layer.cornerRadius = cell.height/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    NSArray *array=[_selectStr componentsSeparatedByString:@" "];
    if ([array count]>0) {
        if([array indexOfObject:[dict objectForKey:@"t_Style_Name"]]  != NSNotFound ){
            [self collectionView:collectionView didSelectItemAtIndexPath:indexPath];
            cell.seleted = YES;
            _myRow = indexPath.row;
        }else{
            cell.layer.borderWidth = 1.0f;
            cell.backgroundColor = [UIColor whiteColor];
            cell.seleted = NO;
        }
    }else{
        cell.layer.borderWidth = 1.0f;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90*PMBWIDTH, 30*PMBWIDTH);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 5, 15);//分别为上、左、下、右
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_Byid==1362 && _myRow < 1000) {
        // 单选
        if (_myRow != indexPath.row) {
        // 如果选中的是不同的cell
        // 先取消选中之前的cell
        NSIndexPath *index = [NSIndexPath indexPathForRow:_myRow inSection:0];
        PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:index];
        cell.seleted = NO;
        cell.layer.borderWidth=1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSDictionary *dict = [_positionlist objectAtIndex:_myRow];
        [DataArray removeObject:dict];
        // 再选中当前选中的cell
        PositionCell *cell1 = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell1.seleted = YES;
        cell1.layer.borderWidth=0.0f;
        [cell1 setBackgroundColor:[UIColor lightGrayColor]];
        NSDictionary *dict1 = [_positionlist objectAtIndex:indexPath.row];
        [DataArray addObject:dict1];
        } else {
          // 如果选中的是同一个cell
            PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.seleted) {
                cell.seleted = NO;
                cell.layer.borderWidth=1.0f;
                [cell setBackgroundColor:[UIColor whiteColor]];
                NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
                [DataArray removeObject:dict];
            } else {
                cell.seleted = YES;
                cell.layer.borderWidth=0.0f;
                [cell setBackgroundColor:[UIColor lightGrayColor]];
                NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
                [DataArray addObject:dict];
            }
        }
    } else {
    // 多选
    PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.seleted) {
        cell.seleted = NO;
        cell.layer.borderWidth=1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
        [DataArray removeObject:dict];
    } else {
        cell.seleted = YES;
        cell.layer.borderWidth=0.0f;
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
        [DataArray addObject:dict];
        }
    }
    _myRow = indexPath.row;

}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_Byid==1362 && _myRow < 1000) {
        // 单选
        if (_myRow != indexPath.row) {
            // 如果选中的是不同的cell
            NSIndexPath *index = [NSIndexPath indexPathForRow:_myRow inSection:0];
            PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:index];
            cell.seleted = NO;
            cell.layer.borderWidth=1.0f;
            [cell setBackgroundColor:[UIColor whiteColor]];
            NSDictionary *dict = [_positionlist objectAtIndex:_myRow];
            [DataArray removeObject:dict];
            PositionCell *cell1 = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
            cell1.seleted = YES;
            cell1.layer.borderWidth=0.0f;
            [cell1 setBackgroundColor:[UIColor lightGrayColor]];
            NSDictionary *dict1 = [_positionlist objectAtIndex:indexPath.row];
            [DataArray addObject:dict1];
        } else {
            // 如果选中的是同一个cell
            PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
            if (cell.seleted) {
                cell.seleted = NO;
                cell.layer.borderWidth=1.0f;
                [cell setBackgroundColor:[UIColor whiteColor]];
                NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
                [DataArray removeObject:dict];
            } else {
                cell.seleted = YES;
                cell.layer.borderWidth=0.0f;
                [cell setBackgroundColor:[UIColor lightGrayColor]];
                NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
                [DataArray addObject:dict];
            }
        }
    } else {
        // 多选
        PositionCell *cell = (PositionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.seleted) {
            cell.seleted = NO;
            cell.layer.borderWidth=1.0f;
            [cell setBackgroundColor:[UIColor whiteColor]];
            NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
            [DataArray removeObject:dict];
        } else {
            cell.seleted = YES;
            cell.layer.borderWidth=0.0f;
            [cell setBackgroundColor:[UIColor lightGrayColor]];
            NSDictionary *dict = [_positionlist objectAtIndex:indexPath.row];
            [DataArray addObject:dict];
        }
    }
    _myRow = indexPath.row;
    
}


@end
