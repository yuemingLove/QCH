//
//  ParntIntCell.h
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParntIntCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *contentLabel;

-(void)setIntroductionText:(NSString*)text;

@end
