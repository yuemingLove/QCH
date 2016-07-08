//
//  TextEntity.m
//  qch
//
//  Created by 苏宾 on 16/3/15.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TextEntity.h"

@implementation TextEntity

- (instancetype)initWithDict:(NSDictionary*)dict{

    self=[super init];
    if (self) {
        self.textId=[(NSNumber*)[dict objectForKey:@"tetxId"]integerValue];
        self.textName=[dict objectForKey:@"textName"];
        self.textContent=[dict objectForKey:@"textContent"];
        self.isShowMoreText = NO;
    }
    return self;
}

@end
