//
//  UIView+Extras.h
//
//  Created by fan on 13-5-23.
//  Copyright (c) 2013年 tes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//#import "Define.h"


typedef enum{
    gradientTopBorder ,gradientBottomBorder,gradientLeftBorder,gradientRightBorder,gradientAllBorder
}GradientBorder;

// 边框方向
typedef enum{
    ViewBorderDirectionTop      = 1 << 0,
    ViewBorderDirectionBottom   = 1 << 1,
    ViewBorderDirectionLeft     = 1 << 2,
    ViewBorderDirectionRight    = 1 << 3,
    ViewBorderDirectionAll      = ViewBorderDirectionTop | ViewBorderDirectionBottom | ViewBorderDirectionLeft | ViewBorderDirectionRight
}ViewBorderDirection;

typedef enum{
    ViewBorderStyleSolid,    // 实心线
    ViewBorderStyleGradient  // 渐变线
}ViewBorderStyle;


typedef enum{
    shadowPathRectangular ,shadowPathTrapezoidal,shadowPathElliptical,shadowPathPapercurl,shadowAround
}ShadowPath;

typedef enum{
    photoFromCamera ,photoFromAlbum
}PhotoSource;


typedef enum{
    alphaOneZeroOne ,alphaZeroOne
}AlphaAnimateType;


@interface UIView (Extras)


@property (nonatomic, assign, readonly) CGPoint midPoint;
@property (nonatomic, assign) CGPoint $origin;
@property (nonatomic, assign) CGSize $size;
@property (nonatomic, assign) CGFloat $x, $y, $width, $height; // normal rect properties
@property (nonatomic, assign) CGFloat $left, $top, $right, $bottom; // these will stretch the rect
@property (nonatomic) int longPressIndex;
@property (nonatomic ,getter = isWobble) BOOL wobble;

- (void)setCornerGradientStyle;
- (void)removeSubviews;
- (void)shadow:(UIColor *)color;
- (UIViewController *) firstAvailableUIViewController;
-(void) addLongPressTarget:(id)target action:(SEL)action;
-(void) addTapTarget:(id)target action:(SEL)action;

-(void) removeTap;
- (void)startWobble;
- (void)stopWobble;
- (void)alphaAnimate:(AlphaAnimateType)type;
- (void)frameAnimate:(CGRect)toFrame duration:(NSTimeInterval)duration;
- (void)frameAnimate:(CGRect)toFrame;
-(CGRect)getWindowRect;
-(CGRect)getAbsoluteRect;

// 渐变边框
-(void)addGradientBorder:(GradientBorder)border;
-(void)addGradientBorder:(GradientBorder)border colors:(NSArray *)colors;
// 边框、圆角
- (void)setViewBorder:(BOOL)radius;
- (void)setViewBorder:(CGFloat)radius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth;

// 渐变背景
-(void)addGradientBackground;
-(void)addGradientBackground:(NSArray *)colors;

// 加边框
-(void)addBorder:(ViewBorderDirection)border
           style:(ViewBorderStyle)style
           width:(CGFloat)width
           color:(UIColor*)color
          offset:(CGFloat)offset;

- (UIImage *)re_screenshot;
 @end
