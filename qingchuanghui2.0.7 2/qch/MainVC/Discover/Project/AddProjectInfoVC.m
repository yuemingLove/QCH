//
//  AddProject1VC.m
//  qch
//
//  Created by 青创汇 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AddProjectInfoVC.h"
#import "PSelectTypeVC.h"
#import "ProductsVC.h"
// 引入FMDB头文件进行项目数据持久化
#import "FMDBHelper.h"
#import "ProjectModel.h"

@interface AddProjectInfoVC ()<UITextFieldDelegate,PSelectTypeVCDelegate>{
     UITextField *scaleTfd;
     UILabel *rongziLab;
     UITextField *useTfd;
     UITextField *profitfd;
     NSString *rongzi;
    UILabel *rongziLabLabel;
}

@end

@implementation AddProjectInfoVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 查询本地数据库中数据并展示
    [self selectFromDataBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"完善项目资料";
    [self createMainView];
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;
}

- (void)createMainView{
    
    rongziLabLabel=[self createLabelFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"融资阶段:"];
    [self.view addSubview:rongziLabLabel];
    
    rongziLab=[[UILabel alloc]initWithFrame:CGRectMake(rongziLabLabel.right+10*SCREEN_WSCALE, rongziLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, rongziLabLabel.height)];
    rongziLab.textAlignment=NSTextAlignmentRight;
    rongziLab.textColor=[UIColor blackColor];
    rongziLab.font=Font(14);
    [self.view addSubview:rongziLab];
    
    UIButton *rongziLabBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rongziLabBtn.frame=rongziLab.frame;
    [rongziLabBtn addTarget:self action:@selector(rongziTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rongziLabBtn];
    
    UIImageView *nextImgeViewFour = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, rongziLab.top+3*SCREEN_WSCALE, 15*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeViewFour.image = [UIImage imageNamed:@"select_next"];
    [self.view addSubview:nextImgeViewFour];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, rongziLabLabel.bottom+8*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line1.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:line1];
    
    UILabel *scaleTfdLabel=[self createLabelFrame:CGRectMake(rongziLabLabel.left, line1.bottom+7*PMBWIDTH, rongziLabLabel.width, rongziLabLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"融资金额:"];
    [self.view addSubview:scaleTfdLabel];
    
    scaleTfd=[self createTextFieldFrame:CGRectMake(scaleTfdLabel.right, scaleTfdLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, scaleTfdLabel.height) font:Font(14) placeholder:@"融资50万/出让10%~15%股份"];
    scaleTfd.textColor=[UIColor blackColor];
    [self.view addSubview:scaleTfd];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, scaleTfdLabel.bottom+8*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line2.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:line2];
    
    UILabel *useTfdLabel=[self createLabelFrame:CGRectMake(rongziLabLabel.left, line2.bottom+7*PMBWIDTH, 200*PMBWIDTH, rongziLabLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"资金使用比例:"];
    [self.view addSubview:useTfdLabel];
    
    useTfd=[self createTextFieldFrame:CGRectMake(rongziLabLabel.left, useTfdLabel.bottom+3*PMBWIDTH, SCREEN_WIDTH-10*SCREEN_WSCALE, rongziLabLabel.height) font:Font(14) placeholder:@"研发费用50%；市场推广35%；管理15%"];
    useTfd.delegate=self;
    useTfd.textColor=[UIColor blackColor];
    [self.view addSubview:useTfd];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, useTfd.bottom+8*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line3.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:line3];
    
    
    UILabel *profitlab = [self createLabelFrame:CGRectMake(rongziLabLabel.left, line3.bottom+7*PMBWIDTH, rongziLabLabel.width, rongziLabLabel.height) color:[UIColor lightGrayColor] font:Font(14) text:@"盈利途径"];
    [self.view addSubview:profitlab];
    
    profitfd = [self createTextFieldFrame:CGRectMake(rongziLabLabel.left, profitlab.bottom+3*PMBWIDTH, ScreenWidth-10*PMBWIDTH, rongziLabLabel.height) font:Font(14) placeholder:@"说说你的项目通过怎样的方式获得收益"];
    profitfd.delegate = self;
    profitfd.textColor = [UIColor blackColor];
    [self.view addSubview:profitfd];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, profitfd.bottom+8*PMBWIDTH, ScreenWidth, 5*PMBWIDTH)];
    line4.backgroundColor = [UIColor themeGrayColor];
    [self.view addSubview:line4];
    
    UIButton *nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(0, 0, 180*PMBWIDTH, 30*PMBWIDTH);
    nextbtn.center = CGPointMake(ScreenWidth/2, line4.bottom+30*PMBWIDTH);
    [nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextbtn.backgroundColor = TSEColor(161, 201, 240);
    nextbtn.titleLabel.font = Font(14);
    nextbtn.layer.cornerRadius = nextbtn.height/2;
    [nextbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbtn];
    
    
}

-(void)rongziTapped:(UIButton*)sender{
    PSelectTypeVC *pSelectType=[[PSelectTypeVC alloc]init];
    pSelectType.selectDelegate=self;
    pSelectType.theme=@"融资阶段-选择";
    pSelectType.type=84;
    [self.navigationController pushViewController:pSelectType animated:YES];
}

-(void)updatePSelectType:(NSDictionary*)dict{
    
    NSInteger pId=[(NSNumber*)[dict objectForKey:@"t_fId"]integerValue];
    if (pId == 84) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            rongziLab.text=[dict objectForKey:@"t_Style_Name"];
            rongzi=[dict objectForKey:@"Id"];
        });
    }
}

- (void)next{
    if ([self isBlankString:rongzi]) {
        [SVProgressHUD showErrorWithStatus:@"请选择融资阶段" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:scaleTfd.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入融资金额" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:useTfd.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入资金使用比例" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:profitfd.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入盈利途径" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    [_addprojectdict setObject:rongzi forKey:@"pFinancePhase"];
    [_addprojectdict setObject:scaleTfd.text forKey:@"pFinance"];
    [_addprojectdict setObject:useTfd.text forKey:@"pFinanceUse"];
    [_addprojectdict setObject:profitfd.text forKey:@"profitway"];
    // 保存数据到数据库
    [self insertIntoDataBase];
    
    ProductsVC *product = [[ProductsVC alloc]init];
    product.addprojectdic = _addprojectdict;
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark - dataBase
// 插入到数据库
- (void)insertIntoDataBase {
    //------------持久化到数据库
    [FMDBHelper shareFMDBHelper].singleProjectModel.pro_financingStage = rongziLab.text;
    [FMDBHelper shareFMDBHelper].singleProjectModel.pro_financingAmount = scaleTfd.text;
    [FMDBHelper shareFMDBHelper].singleProjectModel.pro_capitalUseProportion = useTfd.text;
    [FMDBHelper shareFMDBHelper].singleProjectModel.pro_profitableWay = profitfd.text;
    [FMDBHelper shareFMDBHelper].singleProjectModel.rongzi = rongzi;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]) {
        // 已经创建执行更新数据库
        [[FMDBHelper shareFMDBHelper] updateProjectSetProject:[FMDBHelper shareFMDBHelper].singleProjectModel withPro_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]];
        
    } else {
        // 创建数据库插入数据
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pro_id"];
        [FMDBHelper shareFMDBHelper].singleProjectModel.pro_id = @"1";
        [[FMDBHelper shareFMDBHelper] insertProjectWithProject:[FMDBHelper shareFMDBHelper].singleProjectModel];
    }
  
}
// 从数据库中查询
- (void)selectFromDataBase {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]) {
        ProjectModel *model = [[FMDBHelper shareFMDBHelper] searchProjectWithPro_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"pro_id"]];
        rongziLab.text = model.pro_financingStage;
        scaleTfd.text = model.pro_financingAmount;
        useTfd.text = model.pro_capitalUseProportion;
        profitfd.text = model.pro_profitableWay;
        rongzi = model.rongzi;
    }

}
#pragma mark - backAction
- (void)backAction {
    // 持久化到数据库
    [self insertIntoDataBase];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
