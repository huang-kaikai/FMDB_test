//
//  ViewController.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/5.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "FMDB.h"

@interface ViewController ()
//定义全局成员变量，多線程情形下安全
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FMDB_test";
    
    [self createTable];
    [self insert];
    [self update];
    [self query];
}


/*
 自定义方法：创建表
 */
- (void)createTable{
    //创建数据库路径
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"yyh.db"];
    //打印出數據庫路徑
    NSLog(@"路徑：%@", dbPath);
    //创建数据库DB对象
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"数据库打开成功");
        //创建表格的sql
        NSString *sql = @"create table if not exists user (id integer primary key autoincrement, name text, job text, age integer);";
        //执行sql语句，增、删、改都用executeUpdate
        BOOL result = [db executeUpdate:sql];
        if(result){
            NSLog(@"表创建成功");
        } else {
            NSLog(@"表创建失败");
        }
    }];
    
    
    //关闭数据库
//    [self.db close];
}


/*
 自定义方法：插入数据
 */
- (void)insert{
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *name = @"王先生";
        NSString *job = @"中级工程师";
        int age = 26;
        
        //开启事务
        [db beginTransaction];
        
        //插入sql语句
        NSString *sql = @"insert into user (name, job, age) values (?, ?, ?);";
        //插入数据
        [db executeUpdate:sql, name, job, @(age)];
        
        //提交事务
        [db commit];
        
        NSLog(@"插入数据成功");
     }];
}


/*
 自定义方法：更新数据
 */
- (void)update{
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *job = @"高级工程师";
        int age = 27;
        NSString *name = @"王先生";
        
        //开启事务
        [db beginTransaction];
        
        //更新sql语句
        NSString *sql = @"update user set job = ?, age = ? where name = ?;";
        //插入数据
        [db executeUpdate:sql, job, @(age), name];
        
        //提交事务
        [db commit];
        
        NSLog(@"更新数据成功");
    }];
}


/*
 自定义方法：查询数据
 */
- (void)query{
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *job = @"高级工程师";
        //查询sql语句
        NSString *sql = @"select * from user where job = ?;";
        //查询
        FMResultSet *rs = [db executeQuery:sql, job];
        //循环遍历结果集
        while(rs.next){
            /*
             取出各列的值
             */
            int _id = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *job = [rs stringForColumn:@"job"];
            int age = [rs intForColumn:@"age"];
            //打印结果
            NSLog(@"_id: %d, name: %@, job: %@, age: %d", _id, name, job, age);
        }
   }];
}


/*
 自定义方法1，让增删改在事务中执行1
 */
//- (void)inTransaction1:(FMDatabase *)db {
//    //开启事务
////        [db executeUpdate:@"begin transaction;"];
//    [db beginTransaction];
//
//    //增删改操作代码
//    [db executeUpdate:@"sql语句"];
//
//    if(NO){//需要回滚的条件
//        //回滚事务，取消操作，需要在提交之前执行
////        [db executeUpdate:@"rollback transaction;"];
//        [db rollback];
//    }
//
//    //提交事务
////        [db executeUpdate:@"commit transaction;"];
//    [db commit];
//}



/*
 自定义方法2，让增删改在事务中执行2
 */
- (void)inTransaction2 {
    //此操作在事务中执行
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        //增删改操作代码
        [db executeUpdate:@"sql语句"];
        
        if(NO){//需要回滚的条件
            *rollback = YES; //设置为回滚操作
        }
    }];
}



@end
