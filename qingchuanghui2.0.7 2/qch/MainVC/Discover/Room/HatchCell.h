//
//  HatchCell.h
//  
//
//  Created by 青创汇 on 16/2/27.
//
//

#import <UIKit/UIKit.h>
@class HatchCell;

@protocol HatchCellDelegate <NSObject>

-(void)moreProject:(HatchCell*)cell index:(NSInteger)index;

-(void)selectProject:(HatchCell*)cell index:(NSInteger)index;

@end

@interface HatchCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,assign) id<HatchCellDelegate> hatchDelegate;
@property (nonatomic,assign) NSInteger type;

-(void)updateData:(NSMutableArray *)array;

@end
