//
//  SQL_test_ViewController.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/6.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "SQL_test_ViewController.h"
#import "FMDB.h"

@interface SQL_test_ViewController ()

@property(nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation SQL_test_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SQLite測試";
    
    [self createTable];
    [self insert];
    //[self update];
    [self query];
}

/*
 自定义方法：创建表
 */
- (void)createTable{
    //创建数据库路径
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test5.db"];
    //打印出數據庫路徑
    NSLog(@"路徑：%@", dbPath);
    //创建数据库DB对象
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"数据库打开成功");
        //创建表格的sql
        NSString *sql = @"create table if not exists user (id integer primary key autoincrement, name text, city text, title text);";
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
        NSString *name = @"淘寶女孩";
        NSString *city = @"杜拜";
        NSString *title = @"頭銜";
        
        
        //开启事务
        [db beginTransaction];
        
        //插入sql语句
        NSString *sql = @"insert into user (name, city, title) values (?, ?, ?);";
        //插入数据
        [db executeUpdate:sql, name, city, title];
        
        //提交事务
        [db commit];
        
        NSLog(@"插入数据成功");
     }];
}

/*
 自定义方法：更新数据
 */
//- (void)update{
//    //获取db操作对象
//    [self.dbQueue inDatabase:^(FMDatabase *db) {
//        NSString *job = @"高級淘寶女孩";
//        int age = 27;
//        NSString *name = @"王美麗";
//
//        //开启事务
//        [db beginTransaction];
//
//        //更新sql语句
//        NSString *sql = @"update user set job = ?, age = ? where name = ?;";
//        //插入数据
//        [db executeUpdate:sql, job, @(age), name];
//
//        //提交事务
//        [db commit];
//
//        NSLog(@"更新数据成功");
//    }];
//}

/*
 自定义方法：查询数据
 */
- (void)query{
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *name = @"淘寶女孩";
        //查询sql语句
        NSString *sql = @"select * from user where name = ?;";
        //查询
        FMResultSet *rs = [db executeQuery:sql, name];
        //循环遍历结果集
        while(rs.next){
            /*
             取出各列的值
             */
            int _id = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *city = [rs stringForColumn:@"city"];
            NSString *title = [rs stringForColumn:@"title"];
            //打印结果
            NSLog(@"_id: %d, name: %@, city: %@, title: %@", _id, name, city, title);
        }
   }];
}




@end
