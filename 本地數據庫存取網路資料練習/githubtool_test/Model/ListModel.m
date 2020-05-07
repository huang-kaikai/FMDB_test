//
//  ListModel.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/7.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "ListModel.h"
#import "UserModel.h"

@implementation ListModel

- (void)createArray:(NSDictionary *)result
         dataSource:(NSMutableArray *)dataSource
{
    UserModel *userModel = [[UserModel alloc]init];
    NSArray *array = result[@"contentlist"];
    for (NSDictionary *dict in array) {
        ListModel *listModel = [[ListModel alloc] init];
        listModel.name = [NSString stringWithFormat:@"%@",dict[@"realName"]];
        listModel.city = [NSString stringWithFormat:@"%@",dict[@"city"]];
        listModel.height = [NSString stringWithFormat:@"%@",dict[@"height"]];
        listModel.weight = [NSString stringWithFormat:@"%@",dict[@"weight"]];
        listModel.fansNumber = [NSString stringWithFormat:@"%@",dict[@"totalFanNum"]];
        listModel.jpgURLString = [NSString stringWithFormat:@"%@",dict[@"avatarUrl"]];
        [dataSource addObject:listModel];
        NSLog(@"name:%@",listModel.name);
        
        if (!([userModel selectTable].count > 6)) {
            [userModel insert:listModel];
        }
    }
}

@end
