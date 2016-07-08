//
//  DetialsCell.h
//  qch
//
//  Created by 青创汇 on 16/4/19.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetialsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Introduction;

-(void)setIntroductionText:(NSString*)text;
@end
