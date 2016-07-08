//
//  FMDBHelper.m
//
//  Created on 16/3/15.
//
//

#import "FMDBHelper.h"
#import <FMDB.h>
#import "ProjectModel.h"
#import "ProjectFunModel.h"

@implementation FMDBHelper

- (FMDatabase *)db {
    if (_db == nil) {
        self.db = [FMDatabase databaseWithPath:[self sqlitePath]];
    }
    return _db;
}
- (FMDatabase *)dbF {
    if (_dbF == nil) {
        self.db = [FMDatabase databaseWithPath:[self sqlitePathF]];
    }
    return _dbF;
}

+ (FMDBHelper *)shareFMDBHelper {
    static FMDBHelper *fmdbHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmdbHelper = [[FMDBHelper alloc] init];
        // 创建项目表
        [fmdbHelper createProjectTable];
        // 创建项目图片表
        [fmdbHelper createProjectImageTable];
        // 创建项目合伙人表
        [fmdbHelper createProjectFunTable];
    });
    return fmdbHelper;
}
// 封装获取当前sqlite文件的路径
- (NSString *)sqlitePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接
    NSString *sqlitePath = [documentPath stringByAppendingPathComponent:@"Project.sqlite"];
    Liu_DBG(@"%@", sqlitePath);
    return sqlitePath;
}
- (NSString *)sqlitePathF {
    NSString *documentPathF = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 拼接
    NSString *sqlitePathF = [documentPathF stringByAppendingPathComponent:@"ProjectFun.sqlite"];
    Liu_DBG(@"%@", sqlitePathF);
    return sqlitePathF;
}

// -----------项目表
// 封装创建表的方法
// *创建表,增删改查数据, 都使用execupdate方法
// *只有在查询的时候才使用executeQuery方法
- (void)createProjectTable {
    
    // 创建项目对象
    if (!_singleProjectModel) {
        self.singleProjectModel = [[ProjectModel alloc] init];
    }
    
    // 创建表
    // 打开数据库
    [self.db open];
    // 执行创建表的sqlite语句
    BOOL result = [self.db executeUpdate:@"create table if not exists Project(pro_id text primary key, pro_icon blob, pro_name text, pro_phase text, pro_brief text, pro_city text, pro_field text, pro_describe text, pro_advantage text, pro_users text, pro_financingStage text, pro_financingAmount text, pro_capitalUseProportion text, pro_profitableWay text, pro_productImage1 blob, pro_productImage2 blob, pro_productImage3 blob, pro_productImage4 blob, pro_productImage5 blob, pro_productImage6 blob, pro_productImage7 blob, pro_productImage8 blob, pro_productImage9 blob, pro_websiteLink text, pro_linkLink text, pro_weixinLink text, pro_photoStr text, photoStr text, stage text, territory text, rongzi text)"];
    if (result) {
        Liu_DBG(@"创建Project表成功, Project表已存在");
    }
    // 关闭数据库
    [self.db close];
}

// 插入项目对象
- (void)insertProjectWithProject:(ProjectModel *)project {
    [self.db open];
    // 执行插入表sqlite语句
    // *插入或更改的时候, 数据的值, 使用对象类型, int->nsnumber
    
    BOOL result = [self.db executeUpdate:@"insert into Project(pro_id, pro_icon, pro_name, pro_phase, pro_brief, pro_city, pro_field, pro_describe, pro_advantage, pro_users, pro_financingStage, pro_financingAmount, pro_capitalUseProportion, pro_profitableWay, pro_productImage1, pro_productImage2, pro_productImage3, pro_productImage4, pro_productImage5, pro_productImage6, pro_productImage7, pro_productImage8, pro_productImage9, pro_websiteLink, pro_linkLink, pro_weixinLink, pro_photoStr, photoStr, stage, territory, rongzi) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", project.pro_id, UIImageJPEGRepresentation(project.pro_icon, 1.), project.pro_name, project.pro_phase, project.pro_brief, project.pro_city, project.pro_field, project.pro_describe, project.pro_advantage, project.pro_users, project.pro_financingStage, project.pro_financingAmount, project.pro_capitalUseProportion, project.pro_profitableWay, UIImageJPEGRepresentation(project.pro_productImage1, 1.), UIImageJPEGRepresentation(project.pro_productImage2, 1.), UIImageJPEGRepresentation(project.pro_productImage3, 1.), UIImageJPEGRepresentation(project.pro_productImage4, 1.), UIImageJPEGRepresentation(project.pro_productImage5, 1.), UIImageJPEGRepresentation(project.pro_productImage6, 1.), UIImageJPEGRepresentation(project.pro_productImage7, 1.), UIImageJPEGRepresentation(project.pro_productImage8, 1.), UIImageJPEGRepresentation(project.pro_productImage9, 1.), project.pro_websiteLink, project.pro_linkLink, project.pro_weixinLink, project.pro_photoStr, project.photoStr, project.stage, project.territory, project.rongzi];
    if (result) {
        Liu_DBG(@"插入Project数据成功");
    }
    [self.db close];
}

// 查询
- (ProjectModel *)searchProjectWithPro_id:(NSString *)pro_id {
    [self.db open];
    
    ProjectModel *project = [[ProjectModel alloc] init];
    // FMResultSet:结果集合, 里面都是满足你设置的sql语句条件的结果, 可能一条, 可能多条
    FMResultSet *resultSet = [self.db executeQuery:@"select * from Project where pro_id = ?", pro_id];
    while ([resultSet next]) {
        NSData *pro_icon = [resultSet dataForColumn:@"pro_icon"];
        UIImage *pro_icon_image = [UIImage imageWithData:pro_icon];
        NSString *pro_name = [resultSet stringForColumn:@"pro_name"];
        NSString *pro_phase = [resultSet stringForColumn:@"pro_phase"];
        NSString *pro_brief = [resultSet stringForColumn:@"pro_brief"];
        NSString *pro_city = [resultSet stringForColumn:@"pro_city"];
        NSString *pro_field = [resultSet stringForColumn:@"pro_field"];
        NSString *pro_describe = [resultSet stringForColumn:@"pro_describe"];
        NSString *pro_advantage = [resultSet stringForColumn:@"pro_advantage"];
        NSString *pro_users = [resultSet stringForColumn:@"pro_users"];
        NSString *pro_financingStage = [resultSet stringForColumn:@"pro_financingStage"];
        NSString *pro_financingAmount = [resultSet stringForColumn:@"pro_financingAmount"];
        NSString *pro_capitalUseProportion = [resultSet stringForColumn:@"pro_capitalUseProportion"];
        NSString *pro_profitableWay = [resultSet stringForColumn:@"pro_profitableWay"];
        NSData *pro_productImage1 = [resultSet dataForColumn:@"pro_productImage1"];
        UIImage *pro_productImage1_image = [UIImage imageWithData:pro_productImage1];
        NSData *pro_productImage2 = [resultSet dataForColumn:@"pro_productImage2"];
        UIImage *pro_productImage2_image = [UIImage imageWithData:pro_productImage2];
        NSData *pro_productImage3 = [resultSet dataForColumn:@"pro_productImage3"];
        UIImage *pro_productImage3_image = [UIImage imageWithData:pro_productImage3];
        NSData *pro_productImage4 = [resultSet dataForColumn:@"pro_productImage4"];
        UIImage *pro_productImage4_image = [UIImage imageWithData:pro_productImage4];
        NSData *pro_productImage5 = [resultSet dataForColumn:@"pro_productImage5"];
        UIImage *pro_productImage5_image = [UIImage imageWithData:pro_productImage5];
        NSData *pro_productImage6 = [resultSet dataForColumn:@"pro_productImage6"];
        UIImage *pro_productImage6_image = [UIImage imageWithData:pro_productImage6];
        NSData *pro_productImage7 = [resultSet dataForColumn:@"pro_productImage7"];
        UIImage *pro_productImage7_image = [UIImage imageWithData:pro_productImage7];
        NSData *pro_productImage8 = [resultSet dataForColumn:@"pro_productImage8"];
        UIImage *pro_productImage8_image = [UIImage imageWithData:pro_productImage8];
        NSData *pro_productImage9 = [resultSet dataForColumn:@"pro_productImage9"];
        UIImage *pro_productImage9_image = [UIImage imageWithData:pro_productImage9];
        NSString *pro_websiteLink = [resultSet stringForColumn:@"pro_websiteLink"];
        NSString *pro_linkLink = [resultSet stringForColumn:@"pro_linkLink"];
        NSString *pro_weixinLink = [resultSet stringForColumn:@"pro_weixinLink"];
        NSString *pro_photoStr = [resultSet stringForColumn:@"pro_photoStr"];
        NSString *photoStr = [resultSet stringForColumn:@"photoStr"];
        NSString *stage = [resultSet stringForColumn:@"stage"];
        NSString *territory = [resultSet stringForColumn:@"territory"];
        NSString *rongzi = [resultSet stringForColumn:@"rongzi"];

        // 赋值
        project.pro_icon = pro_icon_image;
        project.pro_name = pro_name;
        project.pro_phase = pro_phase;
        project.pro_brief = pro_brief;
        project.pro_city = pro_city;
        project.pro_field = pro_field;
        project.pro_describe = pro_describe;
        project.pro_advantage = pro_advantage;
        project.pro_users = pro_users;
        project.pro_financingAmount = pro_financingAmount;
        project.pro_financingStage = pro_financingStage;
        project.pro_capitalUseProportion = pro_capitalUseProportion;
        project.pro_profitableWay = pro_profitableWay;
        project.pro_productImage1 = pro_productImage1_image;
        project.pro_productImage2 = pro_productImage2_image;
        project.pro_productImage3 = pro_productImage3_image;
        project.pro_productImage4 = pro_productImage4_image;
        project.pro_productImage5 = pro_productImage5_image;
        project.pro_productImage6 = pro_productImage6_image;
        project.pro_productImage7 = pro_productImage7_image;
        project.pro_productImage8 = pro_productImage8_image;
        project.pro_productImage9 = pro_productImage9_image;
        project.pro_websiteLink = pro_websiteLink;
        project.pro_weixinLink = pro_weixinLink;
        project.pro_linkLink = pro_linkLink;
        project.pro_photoStr = pro_photoStr;
        project.photoStr = photoStr;
        project.stage = stage;
        project.territory = territory;
        project.rongzi = rongzi;
    }
    
    [self.db close];
    return project;
}

// 修改
- (void)updateProjectSetProject:(ProjectModel *)project withPro_id:(NSString *)pro_id {
    [self.db open];
    // 执行修改
    BOOL result = [self.db executeUpdate:@"update Project set pro_icon = ?, pro_name = ?, pro_phase = ?, pro_brief = ?, pro_city = ?, pro_field = ?, pro_describe = ?, pro_advantage = ?, pro_users = ?, pro_financingStage = ?, pro_financingAmount = ?, pro_capitalUseProportion = ?, pro_profitableWay = ?, pro_productImage1 = ?, pro_productImage2 = ?, pro_productImage3 = ?, pro_productImage4 = ?, pro_productImage5 = ?, pro_productImage6 = ?, pro_productImage7 = ?, pro_productImage8 = ?, pro_productImage9 = ?, pro_websiteLink = ?, pro_linkLink = ?, pro_weixinLink = ?, pro_photoStr = ?, photoStr = ?, stage = ?, territory = ?, rongzi = ? where pro_id = ?", UIImageJPEGRepresentation(project.pro_icon, 1.), project.pro_name, project.pro_phase, project.pro_brief, project.pro_city, project.pro_field, project.pro_describe, project.pro_advantage, project.pro_users, project.pro_financingStage, project.pro_financingAmount, project.pro_capitalUseProportion, project.pro_profitableWay, UIImageJPEGRepresentation(project.pro_productImage1, 1.), UIImageJPEGRepresentation(project.pro_productImage2, 1.), UIImageJPEGRepresentation(project.pro_productImage3, 1.), UIImageJPEGRepresentation(project.pro_productImage4, 1.), UIImageJPEGRepresentation(project.pro_productImage5, 1.), UIImageJPEGRepresentation(project.pro_productImage6, 1.), UIImageJPEGRepresentation(project.pro_productImage7, 1.), UIImageJPEGRepresentation(project.pro_productImage8, 1.), UIImageJPEGRepresentation(project.pro_productImage9, 1.), project.pro_websiteLink, project.pro_linkLink, project.pro_weixinLink, project.pro_photoStr, project.photoStr, project.stage, project.territory, project.rongzi, pro_id];
    if (result) {
        Liu_DBG(@"修改Project成功");
    }
    [self.db close];
}
// 删除
- (void)removeProjectWithPro_id:(NSString *)pro_id {
    [self.db open];
    BOOL result = [self.db executeUpdate:@"delete from Project where pro_id = ?", pro_id];
    if (result) {
        Liu_DBG(@"删除Project成功");
    }
    
    [self.db close];
}
// 删除表
- (BOOL) deleteTable:(NSString *)tableName
{
    [self.db open];
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if ([self.db executeUpdate:sqlstr])
    {
        Liu_DBG(@"Delete table SUCESS!");
        return NO;
    }
    [self.db close];
    return YES;
}

//--------------项目图片表

- (void)createProjectImageTable {
    if (!_singleProjectImageModel) {
        self.singleProjectImageModel = [[ProjectModel alloc] init];
    }
    // 创建表
    // 打开数据库
    [self.db open];
    // 执行创建表的sqlite语句
    BOOL result = [self.db executeUpdate:@"create table if not exists ProjectImage(pro_id, pro_productImage1 blob, pro_productImage2 blob, pro_productImage3 blob, pro_productImage4 blob, pro_productImage5 blob, pro_productImage6 blob, pro_productImage7 blob, pro_productImage8 blob, pro_productImage9 blob, pro_websiteLink text, pro_linkLink text, pro_weixinLink text, pro_photoStr text)"];
    if (result) {
        Liu_DBG(@"创建Image表成功, Image表已存在");
    }
    // 关闭数据库
    [self.db close];
}

// 插入项目对象
- (void)insertProjectImageWithProject:(ProjectModel *)project {
    [self.db open];
    // 执行插入表sqlite语句
    // *插入或更改的时候, 数据的值, 使用对象类型, int->nsnumber
    
    BOOL result = [self.db executeUpdate:@"insert into ProjectImage(pro_id, pro_productImage1, pro_productImage2, pro_productImage3, pro_productImage4, pro_productImage5, pro_productImage6, pro_productImage7, pro_productImage8, pro_productImage9, pro_websiteLink, pro_linkLink, pro_weixinLink, pro_photoStr) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", project.pro_id, UIImageJPEGRepresentation(project.pro_productImage1, 1.), UIImageJPEGRepresentation(project.pro_productImage2, 1.), UIImageJPEGRepresentation(project.pro_productImage3, 1.), UIImageJPEGRepresentation(project.pro_productImage4, 1.), UIImageJPEGRepresentation(project.pro_productImage5, 1.), UIImageJPEGRepresentation(project.pro_productImage6, 1.), UIImageJPEGRepresentation(project.pro_productImage7, 1.), UIImageJPEGRepresentation(project.pro_productImage8, 1.), UIImageJPEGRepresentation(project.pro_productImage9, 1.), project.pro_websiteLink, project.pro_linkLink, project.pro_weixinLink, project.pro_photoStr];
    if (result) {
        Liu_DBG(@"插入Image数据成功");
    }
    [self.db close];
}

// 查询
- (ProjectModel *)searchProjectImageWithPro_id:(NSString *)pro_id {
    [self.db open];
    
    ProjectModel *project = [[ProjectModel alloc] init];
    // FMResultSet:结果集合, 里面都是满足你设置的sql语句条件的结果, 可能一条, 可能多条
    FMResultSet *resultSet = [self.db executeQuery:@"select * from ProjectImage where pro_id = ?", pro_id];
    while ([resultSet next]) {
        NSData *pro_productImage1 = [resultSet dataForColumn:@"pro_productImage1"];
        UIImage *pro_productImage1_image = [UIImage imageWithData:pro_productImage1];
        NSData *pro_productImage2 = [resultSet dataForColumn:@"pro_productImage2"];
        UIImage *pro_productImage2_image = [UIImage imageWithData:pro_productImage2];
        NSData *pro_productImage3 = [resultSet dataForColumn:@"pro_productImage3"];
        UIImage *pro_productImage3_image = [UIImage imageWithData:pro_productImage3];
        NSData *pro_productImage4 = [resultSet dataForColumn:@"pro_productImage4"];
        UIImage *pro_productImage4_image = [UIImage imageWithData:pro_productImage4];
        NSData *pro_productImage5 = [resultSet dataForColumn:@"pro_productImage5"];
        UIImage *pro_productImage5_image = [UIImage imageWithData:pro_productImage5];
        NSData *pro_productImage6 = [resultSet dataForColumn:@"pro_productImage6"];
        UIImage *pro_productImage6_image = [UIImage imageWithData:pro_productImage6];
        NSData *pro_productImage7 = [resultSet dataForColumn:@"pro_productImage7"];
        UIImage *pro_productImage7_image = [UIImage imageWithData:pro_productImage7];
        NSData *pro_productImage8 = [resultSet dataForColumn:@"pro_productImage8"];
        UIImage *pro_productImage8_image = [UIImage imageWithData:pro_productImage8];
        NSData *pro_productImage9 = [resultSet dataForColumn:@"pro_productImage9"];
        UIImage *pro_productImage9_image = [UIImage imageWithData:pro_productImage9];
        NSString *pro_websiteLink = [resultSet stringForColumn:@"pro_websiteLink"];
        NSString *pro_linkLink = [resultSet stringForColumn:@"pro_linkLink"];
        NSString *pro_weixinLink = [resultSet stringForColumn:@"pro_weixinLink"];
        NSString *pro_photoStr = [resultSet stringForColumn:@"pro_photoStr"];
        
        // 赋值
        project.pro_productImage1 = pro_productImage1_image;
        project.pro_productImage2 = pro_productImage2_image;
        project.pro_productImage3 = pro_productImage3_image;
        project.pro_productImage4 = pro_productImage4_image;
        project.pro_productImage5 = pro_productImage5_image;
        project.pro_productImage6 = pro_productImage6_image;
        project.pro_productImage7 = pro_productImage7_image;
        project.pro_productImage8 = pro_productImage8_image;
        project.pro_productImage9 = pro_productImage9_image;
        project.pro_websiteLink = pro_websiteLink;
        project.pro_weixinLink = pro_weixinLink;
        project.pro_linkLink = pro_linkLink;
        project.pro_photoStr = pro_photoStr;
    }
    
    [self.db close];
    return project;
}

// 修改
- (void)updateProjectImageSetProject:(ProjectModel *)project withPro_id:(NSString *)pro_id {
    [self.db open];
    // 执行修改
    BOOL result = [self.db executeUpdate:@"update ProjectImage set pro_productImage1 = ?, pro_productImage2 = ?, pro_productImage3 = ?, pro_productImage4 = ?, pro_productImage5 = ?, pro_productImage6 = ?, pro_productImage7 = ?, pro_productImage8 = ?, pro_productImage9 = ?, pro_websiteLink = ?, pro_linkLink = ?, pro_weixinLink = ?, pro_photoStr = ? where pro_id = ?", UIImageJPEGRepresentation(project.pro_productImage1, 1.), UIImageJPEGRepresentation(project.pro_productImage2, 1.), UIImageJPEGRepresentation(project.pro_productImage3, 1.), UIImageJPEGRepresentation(project.pro_productImage4, 1.), UIImageJPEGRepresentation(project.pro_productImage5, 1.), UIImageJPEGRepresentation(project.pro_productImage6, 1.), UIImageJPEGRepresentation(project.pro_productImage7, 1.), UIImageJPEGRepresentation(project.pro_productImage8, 1.), UIImageJPEGRepresentation(project.pro_productImage9, 1.), project.pro_websiteLink, project.pro_linkLink, project.pro_weixinLink, project.pro_photoStr, pro_id];
    if (result) {
        Liu_DBG(@"修改Image成功");
    }
    [self.db close];
}
// 删除
- (void)removeProjectImageWithPro_id:(NSString *)pro_id {
    [self.db open];
    BOOL result = [self.db executeUpdate:@"delete from ProjectImage where pro_id = ?", pro_id];
    if (result) {
        Liu_DBG(@"删除成功");
    }
    
    [self.db close];
}
// 清除表
- (BOOL) eraseTable:(NSString *)tableName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self sqlitePath]]) {
        [self.db open];
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        if ([self.db executeUpdate:sqlstr]) {
            Liu_DBG(@"Erase table sucess!");
            return YES;
        } else {
            Liu_DBG(@"Erase table false!");
        }
        [self.db close];
    }
    return NO;
}

//--------------项目合伙人表

- (void)createProjectFunTable {
    
     //创建项目对象
        if (!_singleProjectFunModel) {
            self.singleProjectFunModel = [[ProjectFunModel alloc] init];
        }
    
    // 创建表
    // 打开数据库
    [self.db open];
    // 执行创建表的sqlite语句
    BOOL result = [self.db executeUpdate:@"create table if not exists ProjectFun(pro_id integer primary key, pro_icon text, pro_name text, pro_remark text, pro_guid text)"];
    if (result) {
        Liu_DBG(@"创建项目合伙人表成功, 表已存在");
    }
    // 关闭数据库
    [self.db close];
}
// 插入项目合伙人对象
- (void)insertProjectFunWithProject:(ProjectFunModel *)project {
    [self.db open];
    // 执行插入表sqlite语句
    // *插入或更改的时候, 数据的值, 使用对象类型, int->nsnumber
    
    BOOL result = [self.db executeUpdate:@"insert into ProjectFun(pro_id, pro_icon, pro_name, pro_remark, pro_guid) values(?, ?, ?, ?, ?)", @(project.pro_id), project.pro_icon, project.pro_name, project.pro_remark, project.pro_guid];
    if (result) {
        Liu_DBG(@"插入项目合伙人数据成功");
    }
    [self.db close];
    
}
// 查询项目合伙人
- (NSMutableArray *)searchProjectFun {
    [self.db open];
    NSMutableArray *array = [NSMutableArray array];
    // FMResultSet:结果集合, 里面都是满足你设置的sql语句条件的结果, 可能一条, 可能多条
    FMResultSet *resultSet = [self.db executeQuery:@"select * from ProjectFun"];
    //判断结果集中是否有数据，如果有则取出数据
    while ([resultSet next]) {
        ProjectFunModel *project = [[ProjectFunModel alloc] init];
//        NSData *pro_icon = [resultSet dataForColumn:@"pro_icon"];
//        UIImage *pro_icon_image = [UIImage imageWithData:pro_icon];
        NSString *pro_icon_image = [resultSet stringForColumn:@"pro_icon"];
        NSString *pro_name = [resultSet stringForColumn:@"pro_name"];
        NSString *pro_remark = [resultSet stringForColumn:@"pro_remark"];
        NSInteger pro_id = [resultSet intForColumn:@"pro_id"];
        NSString *pro_guid = [resultSet stringForColumn:@"pro_guid"];
        // 赋值
        project.pro_icon = pro_icon_image;
        project.pro_name = pro_name;
        project.pro_remark = pro_remark;
        project.pro_id = pro_id;
        project.pro_guid = pro_guid;
        //将查询到的数据放入数组中。
        [array addObject:project];
    }
    
    [self.db close];
    return array;
    
}
// 删除项目合伙人对象
- (void)removeProjectFunWithPro_id:(NSInteger)pro_id {
    [self.db open];
    BOOL result = [self.db executeUpdate:@"delete from ProjectFun where pro_id = ?", pro_id];
    if (result) {
        Liu_DBG(@"删除项目合伙人删除成功");
    }
    
    [self.db close];
    
}

#pragma mark 删除数据库
// 删除数据库
- (void)deleteDatabse
{
    [self.db open];
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // delete the old db.
    if ([fileManager fileExistsAtPath:[self sqlitePath]])
    {
        [self.db close];
        success = [fileManager removeItemAtPath:[self sqlitePath] error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        } else {
            Liu_DBG(@"删除数据库sqlitePath成功");
        }
    }


}

@end
