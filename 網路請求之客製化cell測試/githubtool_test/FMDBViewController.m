//
//  FMDBViewController.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/6.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDB.h"

@interface FMDBViewController ()

@property(nonatomic,strong)FMDatabase *db;

@property(strong,nonatomic)NSString * dbPath;

@property(strong,nonatomic)UITextField *nameTxteField;
@property(strong,nonatomic)UITextField *ageTxteField;



@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
    self.dbPath = fileName;

    //建表
    //2.获得数据库
        FMDatabase *db=[FMDatabase databaseWithPath:self.dbPath];
        //3.打开数据库
        if ([db open]) {
            //4.创表
            BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_userData (id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL, userAge text NOT NULL);"];
            if (result){
                NSLog(@"创表成功");
            }else{
                NSLog(@"创表失败");
            }
        }
        self.db=db;
        
        [self insert];

   
}

//新增数据
-(void)insert{
    BOOL res = [self.db executeUpdate:@"INSERT INTO t_userData (userName, userAge) VALUES (?, ?);", _nameTxteField.text, _ageTxteField.text];
    
    if (!res) {
        NSLog(@"增加数据失败");
    }else{
        NSLog(@"增加数据成功");
        
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"新增数据成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismiss:) withObject:alert afterDelay:0.5];
        */
    }
}

// 删除一条数据
- (void)deleteData:(NSInteger)userid{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        
        NSString *str = [NSString stringWithFormat:@"DELETE FROM t_userData WHERE id = %ld",userid];
        BOOL res = [db executeUpdate:str];
        if (!res) {
            NSLog(@"数据删除失败");
            [self lookData];
        } else {
            NSLog(@"数据删除成功");
            [self lookData];
        }
        [db close];
    }
}

//删除整表数据
//NSString *str = @"DELETE FROM t_userData";

// 更新数据
//- (void)updateData {
//    //获得数据库文件的路径
//    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
//    self.dbPath = fileName;
//
//    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
//    if ([db open]) {
//        NSString *sql = @"UPDATE t_userData SET userName = ? , userAge = ? WHERE id = ?";
//        BOOL res = [db executeUpdate:sql,_nameTxteField.text,_ageTxteField.text,_userId];
//        if (!res) {
//            NSLog(@"数据修改失败");
//        } else {
//            NSLog(@"数据修改成功");
//
//            /*
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据修改成功" preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alert animated:YES completion:nil];
//            [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1.0];
//             */
//        }
//        [db close];
//    }
//}

//查询数据
- (void)lookData {

    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userData.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        
    }
    self.db=db;
    
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_userData"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSString *nameStr = [resultSet stringForColumn:@"userName"];
        //[self.nameArr addObject:nameStr];
        NSString *ageStr = [resultSet stringForColumn:@"userAge"];
        //[self.ageArr addObject:ageStr];
        NSString *idStr = [resultSet stringForColumn:@"id"];
        //[self.idArr addObject:idStr];
    }
    
    //[self.myTableView reloadData];
    
}





@end
