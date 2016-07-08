//
//  WBPopMenuView.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuView.h"
#import "WBTableViewDataSource.h"
#import "WBTableViewDelegate.h"
#import "WBTableViewCell.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

#define WBNUMBER 6

@interface WBPopMenuView ()
@property (nonatomic, strong) WBTableViewDataSource * tableViewDataSource;
@property (nonatomic, strong) WBTableViewDelegate   * tableViewDelegate;
@end

@implementation WBPopMenuView

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame menuFrame:(CGRect)menuFrame
                     menuWidth:(CGFloat)menuWidth
                         items:(NSArray *)items
                        action:(void(^)(NSInteger index))action {
    if (self = [super initWithFrame:frame]) {
        self.menuWidth = menuWidth;
        self.menuItem = items;
        self.action = [action copy];

        self.tableViewDataSource = [[WBTableViewDataSource alloc]initWithItems:items cellClass:[WBTableViewCell class] configureCellBlock:^(WBTableViewCell *cell, WBPopMenuModel *model) {
            WBTableViewCell * tableViewCell = (WBTableViewCell *)cell;
            tableViewCell.textLabel.text = model.title;
            tableViewCell.backgroundColor = TSEAColor(0, 0, 0, 0.8);
            tableViewCell.textLabel.textColor = [UIColor whiteColor];
            tableViewCell.imageView.image = [UIImage imageNamed:model.image];
        }];
        self.tableViewDelegate = [[WBTableViewDelegate alloc]initWithDidSelectRowAtIndexPath:^(NSInteger indexRow) {
            if (self.action) {
                self.action(indexRow);
            }
        }];


        self.tableView = [[UITableView alloc]initWithFrame:menuFrame style:UITableViewStylePlain];
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.delegate = self.tableViewDelegate;
        self.tableView.layer.cornerRadius = 10.0f;
        self.tableView.layer.anchorPoint = CGPointMake(1.0, 0);
        self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.tableView.rowHeight = 40;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self setExtraCellLineHidden:self.tableView];
        [self addSubview:self.tableView];
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return self;
}

-(void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (CGRect)menuFrame {
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width - 72;
    CGFloat menuY = -42;
    CGFloat width = self.menuWidth;
    CGFloat heigh = 40 * WBNUMBER;
    return (CGRect){menuX,menuY,width,heigh};
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect

{
    // 设置背景色
    [TSEAColor(0, 0, 0, 0.8) set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGFloat location = [UIScreen mainScreen].bounds.size.width;
    CGContextMoveToPoint(context,
                         location -  10 - 10,78);//设置起点
    
    CGContextAddLineToPoint(context,
                            location - 2*10 - 10 ,  68);
    
    CGContextAddLineToPoint(context,
                            location - 10 * 3 - 10, 78);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [TSEAColor(0, 0, 0, 0.8) setFill];  //设置填充色
    
    [TSEAColor(0, 0, 0, 0) setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"触摸",@"textOne", nil];
    /*
     *  创建通知
     *  通过通知中心发送通知
     */
    NSNotification *notifiction = [NSNotification notificationWithName:@"dimiss" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notifiction];
    [[WBPopMenuSingleton shareManager]hideMenu];
}

@end
