//
//  GirlsDataModel.h
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/6.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GirlsDataModel : NSObject

@property (nonatomic,strong) NSString *avatarUrl; //头像图片地址
@property (nonatomic,strong) NSString *cardUrl; //封面图片地址
@property (nonatomic,strong) NSString *city; //所在城市
@property (nonatomic,strong) NSString *height; //身高
@property (nonatomic,strong) NSString *weight; //体重
@property (nonatomic,strong) NSString *imgList; //模特图片地址列表
@property (nonatomic,strong) NSString *realName; //名字
@property (nonatomic,strong) NSString *totalFanNum; //粉丝数
@property (nonatomic,strong) NSString *userId; //模特id
@property (nonatomic,strong) NSString *link; //淘女郎url地址

@end

NS_ASSUME_NONNULL_END
