//
//  UserModel.h
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/7.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"
#import "FMDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

#pragma mark -- 建数据库
- (void)openDB;

#pragma mark - 删除数据库
- (BOOL)delteSqlite;

#pragma mark - 检测本地文件是否存在
- (BOOL)isSqliteExist;

#pragma mark - 查询数据库
- (NSMutableArray *)selectTable;

#pragma mark - 插入进表
- (void)insert:(ListModel *)model;

#pragma mark - 更新
- (void)update:(NSString *)value to:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
