//
//  ListModel.h
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/7.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ListModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *height;
@property (nonatomic, copy)NSString *weight;
@property (nonatomic, copy)NSString *fansNumber;
@property (nonatomic, copy)NSString *jpgURLString;

- (void)createArray:(NSDictionary *)result
         dataSource:(NSMutableArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
