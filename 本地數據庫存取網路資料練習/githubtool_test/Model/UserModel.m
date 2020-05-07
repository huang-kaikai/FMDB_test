//
//  UserModel.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/7.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation UserModel

#pragma mark - 删除数据库
- (BOOL)delteSqlite {
    if ([self isSqliteExist]) {
        NSString *path = [NSTemporaryDirectory()stringByAppendingString:@"user.db"];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        [manager removeItemAtPath:path error:&error];
        if (error) {
            NSLog(@"delete sqlite failed");
        }else{
            NSLog(@"delete sqlite success");
        }
        return YES;
    }else{
        NSLog(@"sqlite isn't exist");
        return NO;
    }
    return NO;
}

#pragma mark - 检测本地文件是否存在
- (BOOL)isSqliteExist {
    NSString *path = [NSTemporaryDirectory()stringByAppendingString:@"user.db"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSLog(@"sqlite is exist");
        return YES;
    }else{
        NSLog(@"sqlite isn't exist, prepare to create");
        return NO;
    }
}

#pragma mark -- 建数据库
- (void)openDB {
    NSString *path = [NSTemporaryDirectory()stringByAppendingString:@"user.db"];
    NSLog(@"path:%@",path);
    _db = [FMDatabase databaseWithPath:path];
    if ([_db open]) {
        //建表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS TaoBaoGirlsInfo(id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,city text NOT NULL,height text NOT NULL,weight text NOT NULL,fansNumber text NOT NULL,jpgURLString text NOT NULL)"];
        if (result) {
            NSLog(@"create table success");
        }else{
            NSLog(@"create tabble success");
            [_db close];
        }
    }else{
        [_db close];
        NSLog(@"open db failed");
    }
}

#pragma mark -- 查询数据库
- (NSMutableArray *)selectTable
{
    if (![_db open]) {
        [self openDB];
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([_db open]) {
        FMResultSet *resultSet = [_db executeQuery:@"select *from TaoBaoGirlsInfo;"];
        while ([resultSet next]) {
            ListModel *listModel = [[ListModel alloc]init];
            listModel.name = [resultSet objectForColumnName:@"name"];
            listModel.city = [resultSet objectForColumnName:@"city"];
            listModel.height = [resultSet objectForColumnName:@"height"];
            listModel.weight = [resultSet objectForColumnName:@"weight"];
            listModel.fansNumber = [resultSet objectForColumnName:@"fansNumber"];
            listModel.jpgURLString = [resultSet objectForColumnName:@"jpgURLString"];
            [tempArray addObject:listModel];
        }
        [_db close];
    }
    return tempArray;
    NSLog(@"數據庫查詢結果：%@",tempArray);
}

#pragma mark -- 插入进表
- (void)insert:(ListModel *)model
{
    if (![_db open]) {
        [self openDB];
    }
    [_db executeUpdate:@"INSERT INTO TaoBaoGirlsInfo(name,city,height,weight,fansNumber,jpgURLString)VALUES(?,?,?,?,?,?)",model.name,model.city,model.height,model.weight,model.fansNumber,model.jpgURLString];
}

#pragma mark -- 修改某个值
- (void)update:(NSString *)value to:(NSString *)key {
    if (![_db open]) {
        [self openDB];
    }
    if ([_db open]) {
        NSString *updateSql = [NSString stringWithFormat:@"update TaoBaoGirlsInfo set %@='%@'",key,value];
        BOOL res = [_db executeUpdate:updateSql];
        
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
        [_db close];
    }
}


@end
