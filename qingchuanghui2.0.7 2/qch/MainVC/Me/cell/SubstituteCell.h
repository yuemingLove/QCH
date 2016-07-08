//
//  SubstituteCell.h
//  qch
//
//  Created by W.兵 on 16/6/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubstituteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *endLineImageView;

- (void)updateData:(NSDictionary*)dict;
@end
