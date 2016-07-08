//
//  BestAddDomainVC.h
//  
//
//  Created by 青创汇 on 16/2/22.
//
//

#import "QchBaseViewController.h"

typedef void (^ReturnArrayBlock)(NSArray *SelectedArray);
@interface BestAndDomainVC : QchBaseViewController
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) NSInteger Byid;
@property (nonatomic, strong) NSString *selectStr;

@property (nonatomic,copy)ReturnArrayBlock returnArrayblock;

- (void)returnArray:(ReturnArrayBlock)block;


@end
