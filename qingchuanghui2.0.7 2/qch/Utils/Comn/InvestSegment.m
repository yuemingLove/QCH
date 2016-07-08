//
//  InvestSegment.m
//  qch
//
//  Created by 苏宾 on 16/3/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvestSegment.h"

#define LG_ScreenW [UIScreen mainScreen].bounds.size.width
#define LG_ScreenH [UIScreen mainScreen].bounds.size.height
#define LG_ButtonColor_UnSelected [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:100]

@implementation InvestSegment

#pragma 初始化
- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (NSMutableArray *)buttonList{
    if (!_buttonList){
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (NSMutableArray *)titleList{
    if (!_titleList){
        _titleList = [NSMutableArray array];
    }
    return _titleList;
}

-(void)commonInit {
    
    //按钮名称
    NSMutableArray *titleList = [[NSMutableArray alloc]initWithObjects:@"已接收",@"感兴趣", nil];
    
    self.titleList = titleList;
    
    [self createItem:self.titleList];
    
    [self buttonList];
}

+ (instancetype)initWithTitleList:(NSMutableArray *)titleList {
    
    InvestSegment *segment = [[InvestSegment alloc]initWithTitleList:titleList];
    segment.titleList = titleList;
    return segment;
}



- (void)createItem:(NSMutableArray *)item {
    
    int count = (int)self.titleList.count;
    CGFloat marginX = (self.frame.size.width - count * 60)/(count + 1);
    for (int i = 0; i<count; i++) {
        
        NSString *temp = [self.titleList objectAtIndex:i];
        //按钮的X坐标计算，i为列数
        CGFloat buttonX = marginX + i * (60 + marginX);
        UIButton *buttonItem = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, 60, self.frame.size.height)];
        //设置
        buttonItem.tag = i + 1;
        buttonItem.titleLabel.font=Font(15);
        [buttonItem setTitle:temp forState:UIControlStateNormal];
        [buttonItem setTitleColor:LG_ButtonColor_UnSelected forState:UIControlStateNormal];
        [buttonItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonItem];
        
        [_buttonList addObject:buttonItem];
        //第一个按钮默认被选中
        if (i == 0) {
            CGFloat firstX = buttonX;
            [buttonItem setTitleColor:TSEColor(140, 190, 238) forState:UIControlStateNormal];
            [self creatBanner:firstX];
        }
        
        buttonX += marginX;
    }
    
}

-(void)creatBanner:(CGFloat)firstX{
    //初始化
    CALayer *LGLayer = [[CALayer alloc]init];
    LGLayer.backgroundColor = TSEColor(140, 190, 238).CGColor;
    LGLayer.frame = CGRectMake(firstX-10, self.frame.size.height -2, 80, 2);
    // 设定它的frame
    LGLayer.cornerRadius = 1;// 圆角处理
    [self.layer addSublayer:LGLayer]; // 增加到UIView的layer上面
    self.LGLayer = LGLayer;
    
}

-(void)buttonClick:(id)sender {
    //获取被点击按钮
    UIButton *btn = (UIButton *)sender;
    
    [btn setTitleColor:TSEColor(140, 190, 238) forState:UIControlStateNormal];
    //    NSLog(@"%ld",btn.tag);
    
    UIButton *bt1 = (UIButton *)[self viewWithTag:1];
    UIButton *bt2 = (UIButton *)[self viewWithTag:2];
    
    
    CGFloat bannerX = btn.center.x;
    
    [self bannerMoveTo:bannerX];
    
    switch (btn.tag) {
        case 1:
            [self didSelectButton:bt1];
            [self.delegate scrollToPage:0];
            break;
        case 2:
            [self didSelectButton:bt2];
            [self.delegate scrollToPage:1];
            break;
        default:
            break;
    }
    
    
}

-(void)moveToOffsetX:(CGFloat)offsetX {
    
    UIButton *bt1 = (UIButton *)[self viewWithTag:1];
    UIButton *bt2 = (UIButton *)[self viewWithTag:2];
    
    CGFloat bannerX = bt1.center.x;
    CGFloat offSet = offsetX;
    CGFloat addX = offSet/LG_ScreenW*(bt2.center.x - bt1.center.x);
    
    bannerX += addX;
    
    [self bannerMoveTo:bannerX];
    
    if (bannerX == bt1.center.x) {
        [self didSelectButton:bt1];
    }else if (bannerX == bt2.center.x) {
        [self didSelectButton:bt2];
    }
    
}

-(void)bannerMoveTo:(CGFloat)bannerX{
    //基本动画，移动到点击的按钮下面
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    pathAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(bannerX, 100)];
    //组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:pathAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.duration = 0.3;
    //设置代理
    animationGroup.delegate = self;
    //1.3设置动画执行完毕后不删除动画
    animationGroup.removedOnCompletion=NO;
    //1.4设置保存动画的最新状态
    animationGroup.fillMode=kCAFillModeForwards;
    
    //监听动画
    [animationGroup setValue:@"animationStep1" forKey:@"animationName"];
    //动画加入到changedLayer上
    [_LGLayer addAnimation:animationGroup forKey:nil];
}
//点击按钮后改变字体颜色
-(void)didSelectButton:(UIButton*)Button {
    
    UIButton *bt1 = (UIButton *)[self viewWithTag:1];
    UIButton *bt2 = (UIButton *)[self viewWithTag:2];
    UIButton *btn = Button;
    
    switch (btn.tag) {
        case 1:
            [bt1 setTitleColor:TSEColor(140, 190, 238) forState:UIControlStateNormal];
            [bt2 setTitleColor:LG_ButtonColor_UnSelected forState:UIControlStateNormal];
            
            break;
        case 2:
            [bt1 setTitleColor:LG_ButtonColor_UnSelected forState:UIControlStateNormal];
            [bt2 setTitleColor:TSEColor(140, 190, 238) forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
}

@end
