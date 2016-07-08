//
//  ShowView.m
//  Photo
//
//  Created by lanouhn on 16/3/11.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "ShowView.h"

@implementation ShowView



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    [super touchesEnded:touches withEvent:event];
    self.block();
}




@end
