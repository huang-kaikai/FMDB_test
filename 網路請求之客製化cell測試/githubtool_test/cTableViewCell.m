//
//  cTableViewCell.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/5.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "cTableViewCell.h"

@implementation cTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadComponents];
    }
    return self;
}

-(void)loadComponents {
    
    // 创建图片:cellImage，并添加到cell上
    CGFloat imageX = 10;
    CGFloat imageY = 10;
    CGFloat imageWidth = 200;
    CGFloat imageHeight = 170;
    self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
    self.picture.contentMode = UIViewContentModeScaleAspectFit;
    //self.picture.backgroundColor = [UIColor blueColor];
    [self addSubview:self.picture];
    
    // 创建标题:realName，并添加到cell上
    CGFloat titleX = CGRectGetMaxX(self.picture.frame) + 10;
    CGFloat titleY = 10;
    CGFloat titleWidth = self.frame.size.width - titleX;
    CGFloat titleHeight = 20;
    self.realName = [[UILabel alloc] initWithFrame: CGRectMake(titleX, titleY, titleWidth, titleHeight)];
    //self.realName.text = @"cell的标题";
    self.realName.font = [UIFont systemFontOfSize:18];
    [self addSubview:self.realName];
    
    // 创建内容:城市、身高、體重，并添加到cell上
    CGFloat textX = self.realName.frame.origin.x;
    CGFloat textY = CGRectGetMaxY(self.realName.frame) + 10;
    CGFloat textWidth = titleWidth;
    CGFloat textHeight = 50;
    self.context = [[UILabel alloc] initWithFrame:CGRectMake(textX, textY, textWidth, textHeight)];
    //self.context.text = @"cell的内容xxxx \n xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    self.context.font = [UIFont systemFontOfSize:12];
    self.context.numberOfLines = 0;
    [self addSubview:self.context];
    
    // 创建内容:紛絲數，并添加到cell上
    CGFloat dateX = 10;
    CGFloat dateY = CGRectGetMaxY(self.picture.frame) + 10;
    CGFloat dateWidth = self.frame.size.width - dateX*2;
    CGFloat dateHeight = 20;
    self.totalFanNum = [[UILabel alloc] initWithFrame:CGRectMake(dateX, dateY, dateWidth, dateHeight)];
    //self.totalFanNum.text = @"2020-04-06";
    self.totalFanNum.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.totalFanNum];
}





@end
