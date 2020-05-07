//
//  LocalLoadDataTestViewController.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/7.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "LocalLoadDataTestViewController.h"

#import "cTableViewCell.h"
#import "MJExtension.h"
#import "GirlsDataModel.h"
#import "FMDB.h"
#import "ListModel.h"
#import "UserModel.h"

#define URLSTR @"https://route.showapi.com/126-2?order=&page=&showapi_appid=204064&showapi_timestamp=20200504161139&type=&showapi_sign=a47a2b10b523414dbc214367672e3c45"


@interface LocalLoadDataTestViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *cTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation LocalLoadDataTestViewController

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
    
    
    [self addBtn];
    
    _userModel = [[UserModel alloc]init];
    _dataSource = [[NSMutableArray alloc]initWithCapacity:6];
    
    [self isRequestData];
    
    
}

#pragma mark - 數據庫相關設定
#pragma mark - 添加一个删除数据库的按钮
- (void)addBtn {
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteSqlite)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 删除数据库按钮方法
- (void)deleteSqlite {
    [_userModel delteSqlite];
}

#pragma mark - 本地数据库有值就不请求数据,取本地数据库值
- (void)isRequestData {
    if ([_userModel isSqliteExist]) {
        _dataSource = [_userModel selectTable];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cTableView reloadData];
            NSLog(@"本地數據庫有值，由本地數據庫加載");
        });
    }else{
        //创建一个异步队列解析 json，防止阻塞主线程
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            [self urlStr];
        });
    }
}

#pragma mark -- 解析 JSON
- (void)urlStr
{
    NSURL *url = [NSURL URLWithString:URLSTR];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *error1;
        //解析 json，返回字典，这里解析出来是 unicode 编码，不影响正常显示
        NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
        
        NSDictionary *dict2 = [dict1 valueForKey:@"showapi_res_body"];
        NSDictionary *dict3 = [dict2 valueForKey:@"pagebean"];
        NSLog(@"json解析之字典：%@", dict3);
        ListModel *listModel = [[ListModel alloc] init];
        [listModel createArray:dict3 dataSource:self.dataSource];
        
//        [self.userModel openDB];
//        [self.userModel insert:listModel];
        
        //数据源开始是空的，因为网络等原因...等数据源有值了，在主线程刷新 TabelView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cTableView reloadData];
        });
    }];
    [task resume];
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
    
    ListModel *listModel = _dataSource[indexPath.row];
    
    //設定圖片的url位址
    NSURL *url = [NSURL URLWithString:listModel.jpgURLString];
    //使用NSData的方法將影像指定給UIImage
    UIImage *urlImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:url]];
    
    cell.realName.text = listModel.name;
    cell.context.text = [NSString stringWithFormat:@"城市：%@\n身高：%@\n體重：%@", listModel.city,listModel.height,listModel.weight];
    cell.totalFanNum.text = [NSString stringWithFormat:@"紛絲數：%@", listModel.fansNumber];
    cell.picture.image = urlImage;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //cell最右邊的顯示type
    //cell.backgroundColor = [UIColor whiteColor]; //cell的背景顏色
    
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

//#pragma mark -- getter
//- (UITableView *)cTableView {
//    if (!_cTableView) {
//        _cTableView = [[UITableView alloc]initWithFrame:self.view.frame];
//        _cTableView.delegate = self;
//        _cTableView.dataSource = self;
//    }
//    return _cTableView;
//}



















@end
