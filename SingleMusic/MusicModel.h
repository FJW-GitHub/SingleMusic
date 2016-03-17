//
//  MusicModel.h
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  数据转换为模型
 */
@interface MusicModel : NSObject
@property (nonatomic, copy) NSString *singer;//歌手
@property (nonatomic, copy) NSString *music;//歌名
@property (nonatomic, copy) NSString *singerIcon;//歌手图标
@property (nonatomic,copy) NSArray *desList;//歌手的专辑图片

- (instancetype)initWithInfo:(NSDictionary *)info;//字典数据转换为model
@end
