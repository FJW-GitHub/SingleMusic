//
//  MusicPlayerManage.m
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import "MusicPlayerManage.h"
#import <AVFoundation/AVFoundation.h>
#import "DetailViewController.h"
@interface MusicPlayerManage ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;//音乐播放器对象
    NSInteger curMusicIndex;//当前音乐的下标
    NSTimer *timer;//定时刷新进度
    NSInteger ff;
}
@end



@implementation MusicPlayerManage

+(instancetype)defaultManager{
    static MusicPlayerManage *manager = nil;
    static dispatch_once_t oneTouch;
    dispatch_once(&oneTouch, ^{
    manager = [[MusicPlayerManage alloc]init];
    });
    return manager;
}
/**
 *  播放音乐的方法
 *
 *  @param musicIndex 要播放音乐的下标
 */
-(void)playMusicWithIndex:(NSInteger )musicIndex{
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
        audioPlayer.delegate = nil;
      //TODO 定时器销毁
        [timer invalidate];timer = nil;
    }
    self.curMusicInfo = self.musicList[musicIndex];
    //当前播放那首音乐的下标
    curMusicIndex = musicIndex;
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:self.musicList[musicIndex].music withExtension:nil] error:&error];
    audioPlayer.delegate = self;
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startUpdate) userInfo:nil repeats:YES];
    
    
}
//定时调用的方法 更新进度
-(void)startUpdate{
    
    self.curPlayTime([self returnTime:audioPlayer.currentTime]);
    self.progress(1/audioPlayer.duration*audioPlayer.currentTime);
    
}
-(void)play{
    if (audioPlayer.isPlaying) {
        return;
    }
    timer.fireDate = [NSDate distantPast];//打开定时
    [audioPlayer play];
    
   
}
-(void)pause{
    if (audioPlayer.isPlaying) {
        [audioPlayer pause];
        timer.fireDate = [NSDate distantFuture];//关闭定时
    }
}
-(void)stop{
    if (audioPlayer.isPlaying) {
        [audioPlayer stop];
        [timer invalidate];timer = nil;
    }
}
-(void)next{
    curMusicIndex = _curIndex;
    curMusicIndex++;//当前音乐的下标不能超过音乐的总个数 超过默认跳到第一首歌
    _curIndex = curMusicIndex >= self.musicList.count ? 0 : curMusicIndex;
    [self playMusicWithIndex:_curIndex];
    
}
-(void)back{
    
    curMusicIndex = _curIndex;
    curMusicIndex--;//当前音乐的下标不能低于0 超过默认跳到最后一首歌
    _curIndex = curMusicIndex < 0 ? self.musicList.count-1 : curMusicIndex;
    [self playMusicWithIndex:_curIndex];
   
    

}
- (void)setCurTime:(NSTimeInterval)curTime{
    _curTime = curTime;
    audioPlayer.currentTime = _curTime;
}
-(NSMutableArray<MusicModel *> *)musicList{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MusicList.plist" ofType:nil];
    NSArray *list = [NSArray arrayWithContentsOfFile:path];
    if (list.count == _musicList.count) {
        return _musicList;
    }
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *info in list) {
       [result addObject:[[MusicModel alloc]initWithInfo:info]];
    }
    _musicList = result;
    return result;
}
//播放完毕时调用   单曲循环不调用
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    switch (self.loopType) {
        case Once:
            [self playMusicWithIndex:curMusicIndex];
            break;
        case Order:
            [self next];
            break;
        case Shuffle:
            curMusicIndex = arc4random()%self.musicList.count;
            [self playMusicWithIndex:curMusicIndex];
            break;
            
        default:
            break;
    }
    
}
//设置音量
-(void)setVolume:(float)volume{
    _volume = volume;
    audioPlayer.volume = _volume;
    
}

//-(void)setCurPlayTime:(NSString *)curPlayTime{
//  NSString *time = [self returnTime:audioPlayer.currentTime];
//    _curPlayTime = [time copy];
//}

-(NSString *)allPlayTime{
    NSString *time = [self returnTime:audioPlayer.duration];
    return time;
}
-(NSString *)returnTime:(NSTimeInterval )timeInterval{
    NSInteger m;
    NSInteger s;
    m = timeInterval/60;
    s = (int)timeInterval%60;
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld",m,s];
    return time;
}

@end


