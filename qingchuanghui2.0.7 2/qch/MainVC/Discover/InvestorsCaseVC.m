//
//  InvestorsCaseVC.m
//  qch
//
//  Created by 青创汇 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestorsCaseVC.h"

@interface InvestorsCaseVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *DataArray;
    UIButton *LOGOBtn;
    NSString *LOGOStr;
    UITextField *Projectfield;
    UILabel *StageLab;
    UILabel *DateLab;
    NSMutableArray *StageArray;
    NSString *StateID;

}
@property (nonatomic,strong)UITableView *Casetableview;
@end

@implementation InvestorsCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加投资案例";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(Save:)];
    [self.navigationItem setRightBarButtonItem:item];
    DataArray = @[@"项目名",@"投资阶段",@"日期"];
    [self creatHeaderImg];
    if (!StageArray) {
        StageArray = [[NSMutableArray alloc]init];
    }
}
- (void)creatHeaderImg{
    self.Casetableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.Casetableview.delegate = self;
    self.Casetableview.dataSource = self;
    [self.Casetableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.Casetableview];
    
    UIView *headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130*PMBWIDTH)];
    headerview.backgroundColor = [UIColor whiteColor];
    self.Casetableview.tableHeaderView=headerview;
    
    LOGOBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    LOGOBtn.frame = CGRectMake(0, 0, 80*PMBWIDTH, 80*SCREEN_WSCALE);
    LOGOBtn.center = CGPointMake(ScreenWidth/2, 60*SCREEN_WSCALE);
    LOGOBtn.layer.cornerRadius = LOGOBtn.height/2;
    LOGOBtn.layer.masksToBounds = YES;
    [LOGOBtn setImage:[UIImage imageNamed:@"photo_btn"] forState:UIControlStateNormal];
    [LOGOBtn addTarget:self action:@selector(updatalogo:) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:LOGOBtn];
    
    UILabel *Remindlab = [[UILabel alloc]initWithFrame:CGRectMake(0, LOGOBtn.bottom+6*PMBWIDTH, ScreenWidth, 16*PMBWIDTH)];
    Remindlab.text = @"添加LOGO";
    Remindlab.textColor = [UIColor blackColor];
    Remindlab.textAlignment = NSTextAlignmentCenter;
    Remindlab.font = Font(16);
    [headerview addSubview:Remindlab];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, headerview.bottom-1*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [headerview addSubview:line];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"mycell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [DataArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = Font(14);
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(8*PMBWIDTH, 39*PMBWIDTH, ScreenWidth-8*PMBWIDTH, 1*PMBWIDTH)];
    line.backgroundColor = [UIColor themeGrayColor];
    [cell addSubview:line];
    if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==0) {
        if (!Projectfield) {
            Projectfield = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
            Projectfield.font = Font(14);
            Projectfield.textAlignment = NSTextAlignmentRight;
            [cell addSubview:Projectfield];
        }
    }else if (indexPath.row==1){
        if (!StageLab) {
            StageLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
            StageLab.font = Font(14);
            StageLab.textAlignment = NSTextAlignmentRight;
            [cell addSubview:StageLab];
            
        }
        }else if (indexPath.row==2){
            if (!DateLab) {
                DateLab = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-225*PMBWIDTH, 13*PMBWIDTH, 200*PMBWIDTH, 14*PMBWIDTH)];
                DateLab.font = Font(14);
                DateLab.textAlignment = NSTextAlignmentRight;
                [cell addSubview:DateLab];
            }
            NSString *stagestring = @"";
            NSString *stageID = @"";
            for (int i=0; i<[StageArray count]; i++) {
                NSDictionary *dict = [StageArray objectAtIndex:i];
                NSString *stage = [NSString stringWithFormat:@"%@",[dict objectForKey:@"t_Style_Name"]];
                NSString *ID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
                if ([self isBlankString:stagestring]) {
                    stagestring = stage;
                }else{
                    stagestring = [stagestring stringByAppendingString:[NSString stringWithFormat:@" %@",stage]];
                }
                if ([self isBlankString:stageID]) {
                    stageID = ID;
                }else{
                    stageID = [stageID stringByAppendingString:[NSString stringWithFormat:@";%@",ID]];
                }
            }
            StateID = stageID;
            StageLab.text = stagestring;

        }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        BestAndDomainVC *best =[[BestAndDomainVC alloc]init];
        best.Byid = 95;
        [self.navigationController pushViewController:best animated:YES];
        [best returnArray:^(NSArray *SelectedArray) {
            StageArray = [SelectedArray mutableCopy];
            [self. Casetableview reloadData];
        }];
    }else if (indexPath.row==2){
        //隐藏键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateSelected:date:) origin:DateLab];
        datePicker.minuteInterval = 5;
        [datePicker setMaximumDate:[NSDate new]];
        [datePicker showActionSheetPicker];
    }
}
-(void)dateSelected:(NSDate *)selectedTime date:(id)element {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *date=[dateFormatter stringFromDate:selectedTime];
    [element setText:date];
}
-(void)Save:(id)sender{
    [Projectfield resignFirstResponder];
    
    if ([self isBlankString:LOGOStr]) {
        
        [SVProgressHUD showErrorWithStatus:@"请上传LOGO" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:Projectfield.text]){

        [SVProgressHUD showErrorWithStatus:@"请填写项目名" maskType:SVProgressHUDMaskTypeBlack];
    }else if (Projectfield.text.length>20){
        [SVProgressHUD showErrorWithStatus:@"项目名限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:StageLab.text]){
        
        [SVProgressHUD showErrorWithStatus:@"请选择投资阶段" maskType:SVProgressHUDMaskTypeBlack];
    }else if ([self isBlankString:DateLab.text]){
        
        [SVProgressHUD showErrorWithStatus:@"请选择日期" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showWithStatus:@"添加中……" maskType:SVProgressHUDMaskTypeBlack];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
        [dict setObject:Projectfield.text forKey:@"name"];
        [dict setObject:StateID forKey:@"phase"];
        [dict setObject:DateLab.text forKey:@"date"];
        [dict setObject:LOGOStr forKey:@"base64Pic"];
        [dict setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];
        [HttpPartnerAction AddInvestCase:dict complete:^(id result, NSError *error) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0ull * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            if ([[result objectForKey:@"state"]isEqualToString:@"true"]) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功" maskType:SVProgressHUDMaskTypeBlack];
                NSMutableArray *Array = (NSMutableArray*)[result objectForKey:@"result"];
                if (self.returnArrayblock !=nil) {
                    self.returnArrayblock(Array);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([[result objectForKey:@"state"]isEqualToString:@"false"]){
              
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"result"] maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
    }
}
- (void)updatalogo:(UIButton *)sender
{
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(80*PMBWIDTH, 80*PMBWIDTH)];
            LOGOStr = [CommonDes base64EncodedStringFrom:imageData];
            [LOGOBtn setImage:image forState:UIControlStateNormal];
        }
    }];
}
- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}
-(void)returnArray:(ReturnMutableArray)block{
    self.returnArrayblock = block;
}
@end
