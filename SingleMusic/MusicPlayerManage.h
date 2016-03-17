
//
//  MusicPlayerManage.h
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
//播放器管理类
typedef NS_ENUM(NSUInteger, MusicLoopType) {
    Order = 0,//顺序播放
    Shuffle,//随机播放
    Once,//单曲播放
};
@interface MusicPlayerManage : NSObject
@property (nonatomic,assign) float volume;//设置音量
@property (nonatomic,assign) MusicLoopType loopType;//音乐模式
@property (nonatomic,copy) void(^curPlayTime)(NSString *curPlayTime);//播放的当前时间
@property (nonatomic,copy) NSString *allPlayTime;//播放的总时间
@property (nonatomic,strong) MusicModel *curMusicInfo;//当前播放音乐信息
@property (nonatomic,retain) NSMutableArray<MusicModel *> *musicList;//音乐列表
@property (nonatomic,copy) void(^progress)(float progress);//播放进度
@property (nonatomic, assign) NSTimeInterval curTime;
@property (nonatomic,assign) NSInteger curIndex;//当前音乐的下标
+(instancetype)defaultManager;//创建对象
-(void)playMusicWithIndex:(NSInteger )musicIndex;//通过下标播放歌曲

-(void)play;//播放
-(void)stop;//停止
-(void)pause;//暂停
-(void)next;//下一曲
-(void)back;//上一曲
@end
