//
//  TestViewController.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/5.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "TestViewController.h"
#import "cTableViewCell.h"
#import "MJExtension.h"
#import "GirlsDataModel.h"
#import "FMDB.h"


@interface TestViewController () <UITableViewDelegate,UITableViewDataSource>

@property UITableView *cTableView;
@property (strong,nonatomic) NSArray *dataSource;

//建立數據庫相關屬性
@property(nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"淘寶女孩Demo(由本地數據庫載入)";
    
    //Create TableView
    self.cTableView = [[UITableView alloc]initWithFrame:
                                CGRectMake(0, 0,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height)
                                style:UITableViewStylePlain];
    
    //Add TableView on View
    [self.view addSubview:self.cTableView];
    
    //Regist cTableCell ReuseIdentifier to cTableView
    [self.cTableView registerClass:cTableViewCell.self forCellReuseIdentifier:@"Cell"];
    
    //Set cTableView Delegate
    self.cTableView.dataSource = self;
    self.cTableView.delegate = self;
    
    [self loadData];
    
#pragma mark 數據庫
    [self createTable];
    //[self insert];
    //[self update];
    [self query];
    
    
}


#pragma mark - 發送網路請求
//發送異步請求獲取數據
- (void)loadData {
    NSURL *url = [NSURL URLWithString:@"https://route.showapi.com/126-2?order=&page=&showapi_appid=204064&showapi_timestamp=20200504161139&type=&showapi_sign=a47a2b10b523414dbc214367672e3c45"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"連接錯誤 %@", connectionError);
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
            //解析數據 JSON形式的字符串轉換成OC對象
            //看是數組還是字典
            NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //error為地址，所以用NULL，不用nil
            NSDictionary *dict2 = [dict1 valueForKey:@"showapi_res_body"];
            NSDictionary *dict3 = [dict2 valueForKey:@"pagebean"];
            NSDictionary *dict4 = [dict3 valueForKey:@"contentlist"];
            NSLog(@"%@", dict4);
            
            NSMutableArray *mArray = [GirlsDataModel mj_objectArrayWithKeyValuesArray:dict4];
            self.dataSource = mArray.copy;

        }else{
            NSLog(@"伺服器內部錯誤");
        }
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.cTableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    GirlsDataModel *girls = _dataSource[indexPath.row];
    
    //設定圖片的url位址
    NSURL *url = [NSURL URLWithString:girls.avatarUrl];
    //使用NSData的方法將影像指定給UIImage
    UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    
    cell.realName.text = girls.realName;
    cell.context.text = [NSString stringWithFormat:@"城市：%@\n身高：%@\n體重：%@", girls.city,girls.height,girls.weight];
    cell.totalFanNum.text = [NSString stringWithFormat:@"紛絲數：%@", girls.totalFanNum];
    cell.picture.image = urlImage;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //cell最右邊的顯示type
    //cell.backgroundColor = [UIColor whiteColor]; //cell的背景顏色
    
    //获取db操作对象
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            
            NSString *name = girls.realName;
            NSString *city = girls.city;
            NSString *height = girls.height;
            NSString *weight = girls.weight;
            NSString *fansNumb = girls.totalFanNum;
            NSString *picture = girls.avatarUrl;
            NSLog(@"查看model有無數據：%@", girls.realName);
            
            //开启事务
            [db beginTransaction];
            
            //插入sql语句
            NSString *sql = @"insert into user (name, city, height, weight, fansNumb, picture) values (?, ?, ?, ?, ?, ?);";
            //插入数据
            [db executeUpdate:sql, name, city, height, weight, fansNumb, picture];
            
            //提交事务
            [db commit];
            
            NSLog(@"插入数据成功");
         }];
    
    return cell;
}

//didSelectRowAtIndexPath 選中動畫
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 定义cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}


#pragma mark - 數據庫相關設定
/*
 自定义方法：创建表
 */
- (void)createTable{
    //创建数据库路径
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SQLite2.db"];
    //打印出數據庫路徑
    NSLog(@"路徑：%@", dbPath);
    //创建数据库DB对象
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    //获取db操作对象
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSLog(@"数据库打开成功");
        //创建表格的sql
        NSString *sql = @"create table if not exists user (id integer primary key autoincrement, name text, city text, height text, weight text, fansNumb text, picture text);";
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
        NSString *name = @"王美麗";
        NSString *city = @"杜拜";
        NSString *height = @"168";
        NSString *weight = @"44";
        NSString *fansNumb = @"100";
        NSString *picture = @"image.jpg";
        
//        NSString *name = girls.realName;
//        NSString *city = girls.city;
//        NSString *height = girls.height;
//        NSString *weight = girls.weight;
//        NSString *fansNumb = girls.totalFanNum;
//        NSString *picture = girls.avatarUrl;
//        NSLog(@"查看model有無數據：%@", girls.realName);
        
        //开启事务
        [db beginTransaction];
        
        //插入sql语句
        NSString *sql = @"insert into user (name, city, height, weight, fansNumb, picture) values (?, ?, ?, ?, ?, ?);";
        //插入数据
        [db executeUpdate:sql, name, city, height, weight, fansNumb, picture];
        
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
//        NSString *name = @"王美麗";
//        NSString *city = @"杜拜";
//        NSString *height = @"168";
//        NSString *weight = @"44";
//        NSString *fansNumb = @"100";
//        NSString *picture = @"image.jpg";
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
        NSString *city = @"杭州市";
        //查询sql语句
        NSString *sql = @"select * from user where city = ?;";
        //查询
        FMResultSet *rs = [db executeQuery:sql, city];
        //循环遍历结果集
        while(rs.next){
            /*
             取出各列的值
             */
            int _id = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
            NSString *city = [rs stringForColumn:@"city"];
            NSString *height = [rs stringForColumn:@"height"];
            NSString *weight = [rs stringForColumn:@"weight"];
            NSString *fansNumb = [rs stringForColumn:@"fansNumb"];
            NSString *picture = [rs stringForColumn:@"picture"];
            //打印结果
            NSLog(@"_id: %d, name: %@, city: %@, height: %@, weight: %@, fansNumb: %@, picture: %@",  _id, name, city, height, weight, fansNumb, picture);
        }
   }];
    [self.cTableView reloadData];
    NSLog(@"從數據庫載入");
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
