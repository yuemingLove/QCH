//
//  PresentCell.h
//  
//
//  Created by 青创汇 on 16/2/27.
//
//

#import <UIKit/UIKit.h>

@interface PresentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *RoomName;

@property (weak, nonatomic) IBOutlet UILabel *RoomRmark;

@property (weak, nonatomic) IBOutlet UILabel *RoomTrans;

-(void)setIntroductionText:(NSString*)text;

@end
