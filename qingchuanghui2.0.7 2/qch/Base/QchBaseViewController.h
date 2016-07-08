//
//  QchBaseViewController.h
//  qch
//
//  Created by 苏宾 on 15/12/25.
//  Copyright © 2015年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QchBaseViewController : UIViewController

-(void)setNavBarTitle:(NSString *)str;

-(void)linketoRongyun:(NSString *)tookenString;

-(void)getRYToken:(NSString *)Guid;

-(void)ShareIntegral:(NSString *)type;

//TabBar控制
- (void)hideTabBar:(UIViewController *)vc;
- (void)showTabBar:(UIViewController *)vc;
-(void)showAlertWithTitle:(NSString *)titleString;
- (BOOL)isBlankString:(NSString *)string;


-(UITextField *)createTextFieldFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder;

-(UILabel *)createLabelFrame:(CGRect)frame color:(UIColor*)color font:(UIFont *)font text:(NSString *)text;


-(NSString *)stringChangDate:(NSString *)date;

@end
