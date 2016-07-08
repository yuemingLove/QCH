//
//  PartnerSelectVC.m
//  
//
//  Created by 青创汇 on 16/2/22.
//
//

#import "PartnerSelectVC.h"

@interface PartnerSelectVC ()<UIScrollViewDelegate>{
    NSString *DomainStr;
    NSString *BestStr;
    
    UIView *firstView;
    UIView *SecondView;

    UILabel *firstLab;
    UILabel *secondLab;
    
    CGFloat width;

}

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong)NSMutableArray *DomainArray;
@property (nonatomic,strong)NSMutableArray *BestArray;

@end

@implementation PartnerSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合伙人筛选";
    [self createFrame];
    
}


-(void)createFrame{
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(0, _scrollView.bottom, SCREEN_WIDTH, 50);
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundColor:[UIColor themeBlueThreeColor]];
    [selectBtn addTarget:self action:@selector(selectData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    [self createDataView];
}
-(void)createDataView{

    width=(SCREEN_WIDTH-60*SCREEN_WSCALE)/3;
    
    for (NSDictionary *typeDict in _typelist) {
        NSInteger typeId = [(NSNumber *)[typeDict objectForKey:@"Id"]integerValue];
        if (typeId==80) {
            _DomainArray = [NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
        }else if (typeId==81){
            _BestArray = [NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
        }
    }
    
    firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ([_DomainArray count]/3 +1)*45+24*SCREEN_WSCALE)];
    [firstView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:firstView];
    
    firstLab=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"关注领域"];
    [firstView addSubview:firstLab];
    
    for (int i=0; i<[_DomainArray count]; i++) {
        NSDictionary *dict = [_DomainArray objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), firstLab.bottom+5+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectFristType:) forControlEvents:UIControlEventTouchUpInside];
        [firstView addSubview:button];
    }
    
    SecondView=[[UIView alloc]initWithFrame:CGRectMake(0, firstView.bottom, SCREEN_WIDTH, ([_BestArray count]/3 +1)*45+24*SCREEN_WSCALE)];
    [SecondView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:SecondView];
    
    secondLab=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"我最擅长"];
    [SecondView addSubview:secondLab];
    
    for (int i=0; i<[_BestArray count]; i++) {
        NSDictionary *dict = [_BestArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), secondLab.bottom+5+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectSecordType:) forControlEvents:UIControlEventTouchUpInside];
        [SecondView addSubview:button];
    }
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, (firstView.height+SecondView.height+30*SCREEN_WSCALE))];
}

-(void)selectFristType:(UIButton *)sender{
    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_DomainArray objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        
        DomainStr=@"";
    }else{
        
        firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ([_DomainArray count]/3 +1)*45+24*SCREEN_WSCALE)];
        [firstView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:firstView];
        
        firstLab=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"关注领域"];
        [firstView addSubview:firstLab];
        
        for (int i=0; i<[_DomainArray count]; i++) {
            
            NSDictionary *dict=[_DomainArray objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), firstLab.bottom+5+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=TSEColor(190, 190, 190);
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectFristType:) forControlEvents:UIControlEventTouchUpInside];
            [firstView addSubview:button];
        }
        DomainStr=str;
    }
}

-(void)selectSecordType:(UIButton*)sender{
    
    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_BestArray objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        
        BestStr=@"";
    }else{
        
        SecondView=[[UIView alloc]initWithFrame:CGRectMake(0, firstView.bottom, SCREEN_WIDTH, ([_BestArray count]/3 +1)*45+24*SCREEN_WSCALE)];
        [SecondView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:SecondView];
        
        secondLab=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"我最擅长"];
        [SecondView addSubview:secondLab];
        
        for (int i=0; i<[_BestArray count]; i++) {
            
            NSDictionary *dict=[_BestArray objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), secondLab.bottom+5+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=TSEColor(190, 190, 190);
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectSecordType:) forControlEvents:UIControlEventTouchUpInside];
            [SecondView addSubview:button];
        }
        BestStr=str;
    }
    
}
-(void)selectData:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:DomainStr forKey:@"domain"];
    [[NSUserDefaults standardUserDefaults] setObject:BestStr forKey:@"best"];
    [[NSUserDefaults standardUserDefaults] setObject:@"reflesh" forKey:@"reflesh"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
