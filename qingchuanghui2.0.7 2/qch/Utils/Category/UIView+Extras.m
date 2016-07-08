//
//  UIView+Extras.m
//
//  Created by fan on 13-5-23.
//  Copyright (c) 2013年 tes. All rights reserved.
//

#import "UIView+Extras.h"
#import <objc/runtime.h>

static char const * const lPIndex = "longPressIndex";

@implementation UIView (Extras)


- (CGPoint)midPoint{
    return CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}
- (CGPoint)$origin { return self.frame.origin; }
- (void)set$origin:(CGPoint)origin { self.frame = (CGRect){ .origin=origin, .size=self.frame.size }; }

- (CGFloat)$x { return self.frame.origin.x; }
- (void)set$x:(CGFloat)x { self.frame = (CGRect){ .origin.x=x, .origin.y=self.frame.origin.y, .size=self.frame.size }; }

- (CGFloat)$y { return self.frame.origin.y; }
- (void)set$y:(CGFloat)y { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=y, .size=self.frame.size }; }

- (CGSize)$size { return self.frame.size; }
- (void)set$size:(CGSize)size { self.frame = (CGRect){ .origin=self.frame.origin, .size=size }; }

- (CGFloat)$width { return self.frame.size.width; }
- (void)set$width:(CGFloat)width { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height }; }

- (CGFloat)$height { return self.frame.size.height; }
- (void)set$height:(CGFloat)height { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height }; }

- (CGFloat)$left { return self.frame.origin.x; }
- (void)set$left:(CGFloat)left { self.frame = (CGRect){ .origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x+self.frame.size.width-left,0), .size.height=self.frame.size.height }; }

- (CGFloat)$top { return self.frame.origin.y; }
- (void)set$top:(CGFloat)top { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y+self.frame.size.height-top,0) }; }

- (CGFloat)$right { return self.frame.origin.x + self.frame.size.width; }
- (void)set$right:(CGFloat)right { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=fmaxf(right-self.frame.origin.x,0), .size.height=self.frame.size.height }; }

- (CGFloat)$bottom { return self.frame.origin.y + self.frame.size.height; }
- (void)set$bottom:(CGFloat)bottom { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom-self.frame.origin.y,0) }; }


- (int)longPressIndex{
    // Retrieve NSNumber object associated with self and convert to float value
    return [objc_getAssociatedObject(self, lPIndex) intValue];
}
- (void)setLongPressIndex:(int)index{
    // Convert float value to NSNumber object and associate with self
    objc_setAssociatedObject(self, lPIndex, [NSNumber numberWithInt:index],  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

BOOL _wobble;

-(void) setWobble:(BOOL)wobble
{
    _wobble = wobble;
}

-(BOOL) isWobble
{
    return _wobble;
}

- (void)setViewBorder:(CGFloat)radius borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth{
    @try {
        if (borderColor == nil) {
            self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }else{
            
            self.layer.borderColor = borderColor;
        }
        [self.layer setBorderWidth:borderWidth];
        self.layer.cornerRadius = radius;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)setViewBorder:(BOOL)radius{
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//    CGFloat values[4] = {0.5, 0.5, 0.5, 1.0};
//    CGColorRef grey = CGColorCreate(space, values);
    self.layer.borderColor = [UIColor colorWithWhite:204.0f/255.0f alpha:1].CGColor;
    
    [self.layer setBorderWidth:1];
    if (radius) {
        self.layer.cornerRadius = 5;
    }
}

- (void)setCornerGradientStyle{
    @try {
    
    if ([self.layer.sublayers count] <= 3) {
        //    // Get the button layer and give it rounded corners with a semi-transparant button
        CALayer *layer = self.layer;
        layer.cornerRadius = 8.0f;
        layer.masksToBounds = YES;
        layer.borderWidth = 4.0f;
        layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
        
        //    // Create a shiny layer that goes on top of the button
        CAGradientLayer *shineLayer = [CAGradientLayer layer];
        shineLayer.frame = self.layer.bounds;
        
        //    // Set the gradient colors
        shineLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                             (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                             nil];
        
        // Set the relative positions of the gradien stops
        shineLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.5f],
                                [NSNumber numberWithFloat:0.8f],
                                [NSNumber numberWithFloat:1.0f],
                                nil];
        
        // Add the layer to the button
        [self.layer addSublayer:shineLayer];
        
    }
    
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGFloat values[4] = {0.5, 0.5, 0.5, 1.0};
    CGColorRef grey = CGColorCreate(space, values);
    
    self.layer.borderColor = grey;
    [self.layer setBorderWidth:1];
        self.layer.cornerRadius = 6;
        
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (void)removeSubviews{
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}

- (void)shadow:(UIColor *)color{
    if (color == nil) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
    }else{
        self.layer.shadowColor = color.CGColor;
    }
    
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.layer.shadowRadius = 2.0f;
    self.layer.masksToBounds = NO;
    CGPathRef path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowPath = path;
    //CGPathRelease(path);
}


-()getShadowPath:(ShadowPath)spath{
    CGSize size = self.bounds.size;
    UIBezierPath *path;
    if (spath ==shadowPathRectangular) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(size.width * 0.33f, size.height * 0.66f)];
        [path addLineToPoint:CGPointMake(size.width * 0.66f, size.height * 0.66f)];
        [path addLineToPoint:CGPointMake(size.width * 1.15f, size.height * 1.15f)];
        [path addLineToPoint:CGPointMake(size.width * -0.15f, size.height * 1.15f)];
    }else if (spath ==shadowPathTrapezoidal) {
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(size.width * 0.33f, size.height * 0.66f)];
        [path addLineToPoint:CGPointMake(size.width * 0.66f, size.height * 0.66f)];
        [path addLineToPoint:CGPointMake(size.width * 1.15f, size.height * 1.15f)];
        [path addLineToPoint:CGPointMake(size.width * -0.15f, size.height * 1.15f)];
    }else if (spath ==shadowPathElliptical) {
        CGRect ovalRect = CGRectMake(0.0f, size.height + 5, size.width - 10, 15);
        path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    }else if (spath ==shadowPathPapercurl) {
        CGFloat curlFactor = 15.0f;
        CGFloat shadowDepth = 5.0f;
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(size.width, 0.0f)];
        [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
        [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
                controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
                controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    }
    return path;
}

- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

 

#pragma mark - longPress
-(void) addLongPressTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    //长按手势
    UILongPressGestureRecognizer *longGnizer =  [[UILongPressGestureRecognizer alloc]initWithTarget:target
                                                            action:action];
    [self addGestureRecognizer:longGnizer];
}

-(void) addTapTarget:(id)target action:(SEL)action{
    self.userInteractionEnabled = YES;
    
    [self setMultipleTouchEnabled:YES];
    //长按手势
    UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    
}



-(void) removeTap{
    for (UIGestureRecognizer *gen in self.gestureRecognizers) {
        if ([gen isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gen];
            break;
        }
    }
}

//-(void)tap:(UITapGestureRecognizer *)aGer{
//    if (aGer.state==UIGestureRecognizerStateBegan) {
//        // NSLog(@"%s",__func__);
//    }
//    
//}
//
//
//-(void)longPress:(UILongPressGestureRecognizer *)aGer{
//    if (aGer.state==UIGestureRecognizerStateBegan) {
//       // NSLog(@"%s",__func__);
//    }
//    
//}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#pragma mark - animation 
- (void)startWobble {
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5));
    
    self.wobble = YES;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5));
                     }
                     completion:NULL
     ];
}

- (void)stopWobble {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.transform = CGAffineTransformIdentity;
                         self.wobble = NO;
                     }
                     completion:NULL
     ];
}

- (void)alphaAnimate:(AlphaAnimateType)type
{
    NSTimeInterval time = 0.0;
    if (type == alphaOneZeroOne) {
        time = 0.3;
    }else if (type == alphaZeroOne) {
        time = 0.0;
    }
    [UIView animateWithDuration:time
                     animations:^{
                         self.alpha = 0.0; 
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:time
                                          animations:^{
                                              self.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
}



- (void)frameAnimate:(CGRect)toFrame duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         self.frame = toFrame;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)frameAnimate:(CGRect)toFrame
{
    [self frameAnimate:toFrame duration:0.2];
}

CGRect XYWidthHeightRectSwap(CGRect rect) {
    CGRect newRect;
    newRect.origin.x = rect.origin.y;
    newRect.origin.y = rect.origin.x;
    newRect.size.width = rect.size.height;
    newRect.size.height = rect.size.width;
    return newRect;
}

CGRect FixOriginRotation(CGRect rect, UIInterfaceOrientation orientation, int parentWidth, int parentHeight) {
    CGRect newRect;
    switch(orientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), rect.origin.y, rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationLandscapeRight:
            newRect = CGRectMake(rect.origin.x, parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        case UIInterfaceOrientationPortrait:
            newRect = rect;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            newRect = CGRectMake(parentWidth - (rect.size.width + rect.origin.x), parentHeight - (rect.size.height + rect.origin.y), rect.size.width, rect.size.height);
            break;
        default:
            break;
    }
    return newRect;
}


-(CGRect)getWindowRect{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect windowRect = [[UIApplication sharedApplication]delegate].window.bounds;
    if (UIInterfaceOrientationLandscapeLeft == orientation ||UIInterfaceOrientationLandscapeRight == orientation ) {
       return  windowRect = XYWidthHeightRectSwap(windowRect);
    }
    return windowRect;
}

-(CGRect)getAbsoluteRect{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect viewRectAbsolute = [self  convertRect:self.bounds toView:nil];
    if (UIInterfaceOrientationLandscapeLeft == orientation ||UIInterfaceOrientationLandscapeRight == orientation ) {
        return viewRectAbsolute = XYWidthHeightRectSwap(viewRectAbsolute);
    }
    return viewRectAbsolute;
}


-(void)addGradientBorder:(GradientBorder)border{
    NSArray *colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor,(id)[UIColor lightGrayColor].CGColor,(id)[UIColor clearColor].CGColor,nil];
    [self addGradientBorder:border colors:colors];
}

-(void)addGradientBorder:(GradientBorder)border colors:(NSArray *)colors{
    //下部边框
    CAGradientLayer *borderLine = [[CAGradientLayer alloc] init];
    borderLine.colors = colors;
    
    CGFloat borderWidth = 1/[[UIScreen mainScreen] scale];
    
    if (border == gradientBottomBorder) {
        borderLine.frame = CGRectMake(0, self.frame.size.height-borderWidth, self.frame.size.width, borderWidth);
        borderLine.startPoint = CGPointMake(0, 0.5);
        borderLine.endPoint = CGPointMake(1.0, 0.5);
    }else if (border == gradientTopBorder) {
        borderLine.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
        borderLine.startPoint = CGPointMake(0, 0.5);
        borderLine.endPoint = CGPointMake(1.0, 0.5);
    }else if (border == gradientLeftBorder) {
        borderLine.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
        borderLine.startPoint=CGPointMake(0.5, 0);
        borderLine.endPoint=CGPointMake(0.5, 1.0);
    }else if (border == gradientRightBorder) {
        borderLine.frame = CGRectMake(self.frame.size.width-borderWidth, 0, borderWidth, self.frame.size.height);
        borderLine.startPoint=CGPointMake(0.5, 0);
        borderLine.endPoint=CGPointMake(0.5, 1.0);
    }
    [self.layer addSublayer:borderLine];
}


-(void)addGradientBackground{
    NSArray *colors = [NSArray arrayWithObjects:
                              (id)[UIColor colorWithWhite: 1.00 alpha:1].CGColor,
                              (id)[UIColor colorWithWhite: 1.00 alpha:1].CGColor,
                              (id)[UIColor colorWithWhite: 0.94 alpha:1].CGColor,
                              (id)[UIColor colorWithWhite: 0.88 alpha:1].CGColor,
                              nil];
    [self addGradientBackground:colors];
}

- (void)addGradientBackground:(NSArray *)colors{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    CGRect frame = self.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    gradient.frame = frame;
    gradient.colors =colors;
    [self.layer insertSublayer:gradient atIndex:0];
}

// 加边框
-(void)addBorder:(ViewBorderDirection)border
           style:(ViewBorderStyle)style
           width:(CGFloat)width
           color:(UIColor*)color
          offset:(CGFloat)offset
{
    NSMutableArray *borders = [NSMutableArray array];
    
    // top
    if ((border & ViewBorderDirectionTop) == ViewBorderDirectionTop) {
        CALayer *layer;
        if (style == ViewBorderStyleGradient) {
            layer = [[CAGradientLayer alloc]init];
            
            ((CAGradientLayer*)layer).startPoint = CGPointMake(0, 0.5);
            ((CAGradientLayer*)layer).endPoint = CGPointMake(1.0, 0.5);
        }else{
            layer = [[CALayer alloc]init];
        }
        
        layer.frame = CGRectMake(offset, 0, self.frame.size.width - 2 * offset, width);
        [borders addObject:layer];
    }
    // bottom
    if ((border & ViewBorderDirectionBottom) == ViewBorderDirectionBottom) {
        CALayer *layer;
        if (style == ViewBorderStyleGradient) {
            layer = [[CAGradientLayer alloc]init];
            ((CAGradientLayer*)layer).startPoint = CGPointMake(0, 0.5);
            ((CAGradientLayer*)layer).endPoint = CGPointMake(1.0, 0.5);
        }else{
            layer = [[CALayer alloc]init];
        }
        
        layer.frame = CGRectMake(offset, self.frame.size.height-width, self.frame.size.width - 2 * offset, width);
        [borders addObject:layer];
    }
    // left
    if ((border & ViewBorderDirectionLeft) == ViewBorderDirectionLeft) {
        CALayer *layer;
        if (style == ViewBorderStyleGradient) {
            layer = [[CAGradientLayer alloc]init];
            ((CAGradientLayer*)layer).startPoint = CGPointMake(0.5, 0);
            ((CAGradientLayer*)layer).endPoint = CGPointMake(0.5, 1);
        }else {
            layer = [[CALayer alloc]init];
        }
        
        layer.frame = CGRectMake(0, offset, width, self.frame.size.height - 2 * offset);
        [borders addObject:layer];
    }
    // right
    if ((border & ViewBorderDirectionRight) == ViewBorderDirectionRight) {
        CALayer *layer;
        if (style == ViewBorderStyleGradient) {
            layer  = [[CAGradientLayer alloc]init];
            ((CAGradientLayer*)layer).startPoint=CGPointMake(0.5, 0);
            ((CAGradientLayer*)layer).endPoint=CGPointMake(0.5, 1.0);
        }else {
            layer  = [[CALayer alloc]init];
        }
        
        layer.frame = CGRectMake(self.frame.size.width-width-1, offset, width, self.frame.size.height - 2 * offset);
        [borders addObject:layer];
    }
    
    for (CALayer *layer in borders) {
        if (style == ViewBorderStyleGradient) {
            ((CAGradientLayer*)layer).colors = @[(id)[UIColor clearColor].CGColor,
                                                 (id)color.CGColor,
                                                 (id)[UIColor clearColor].CGColor];
        }else if (style == ViewBorderStyleSolid){
            layer.backgroundColor = color.CGColor;
        }
        [self.layer addSublayer:layer];
    }
}

- (UIImage *)re_screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        
        NSInvocation* invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:
                                @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
