//
//  PartnerneedsCell.h
//  qch
//
//  Created by 青创汇 on 16/4/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerneedsCell : UITableViewCell

@property (nonatomic,strong) UIView *fristView;

- (void)updateFrame:(NSDictionary*)dict;

-(void)setFrameHeight:(NSDictionary*)dict;
@end
