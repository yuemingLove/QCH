//
//  TextEntity.h
//  qch
//
//  Created by 苏宾 on 16/3/15.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextEntity : NSObject

@property (nonatomic,assign) NSInteger textId;
@property (nonatomic,strong) NSString *textName;
@property (nonatomic,strong) NSString *textContent;

//是否展示全部
@property (nonatomic,assign) BOOL isShowMoreText;

- (instancetype)initWithDict:(NSDictionary*)dict;

@end
