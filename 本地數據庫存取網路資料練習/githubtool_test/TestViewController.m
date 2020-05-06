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


@interface TestViewController () <UITableViewDelegate,UITableViewDataSource>

@property UITableView *cTableView;
@property (strong,nonatomic) NSArray *dataSource;

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








@end
