//
//  cTableViewCell.h
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/5.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface cTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *realName;
@property (nonatomic,strong) UILabel *context;
@property (nonatomic,strong) UILabel *totalFanNum;
@property (nonatomic,strong) UIImageView *picture;


@end

NS_ASSUME_NONNULL_END
