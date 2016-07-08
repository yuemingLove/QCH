//
//  FMDBHelper.h
//
//  Created on 16/3/15.
//
//

#import <Foundation/Foundation.h>
@class FMDatabase, ProjectModel, ProjectFunModel;

@interface FMDBHelper : NSObject
// 声明一个数据库属性
// 执行增删改查都是数据库兑现调用方法
@property (nonatomic, strong)FMDatabase *db;// 项目表db
@property (nonatomic, strong)FMDatabase *dbF;// 合伙人db
@property (nonatomic, strong)ProjectModel *singleProjectModel;// 添加的项目对象
@property (nonatomic, strong)ProjectModel *singleProjectImageModel;// 添加的项目图片对象
@property (nonatomic, strong)ProjectFunModel *singleProjectFunModel;// 添加的项目合伙人对象

+ (FMDBHelper *)shareFMDBHelper;

//------------项目表
// 插入项目对象
- (void)insertProjectWithProject:(ProjectModel *)project;
// 查询
- (ProjectModel *)searchProjectWithPro_id:(NSString *)pro_id;
// 修改
- (void)updateProjectSetProject:(ProjectModel *)project withPro_id:(NSString *)pro_id;
// 删除
- (void)removeProjectWithPro_id:(NSString *)pro_id;
// 删除表
- (BOOL) deleteTable:(NSString *)tableName;
//------------项目图片表
// 插入项目对象
- (void)insertProjectImageWithProject:(ProjectModel *)project;
// 查询
- (ProjectModel *)searchProjectImageWithPro_id:(NSString *)pro_id;
// 修改
- (void)updateProjectImageSetProject:(ProjectModel *)project withPro_id:(NSString *)pro_id;
// 删除
- (void)removeProjectImageWithPro_id:(NSString *)pro_id;
//------------项目合伙人表
// 插入项目合伙人对象
- (void)insertProjectFunWithProject:(ProjectFunModel *)project;
// 查询
- (NSMutableArray *)searchProjectFun;
// 删除
- (void)removeProjectFunWithPro_id:(NSInteger)pro_id;
// 清除表-清数据
- (BOOL) eraseTable:(NSString *)tableName;
//-----------
// 删除数据库
- (void)deleteDatabse;
@end
