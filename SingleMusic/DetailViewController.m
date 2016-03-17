//
//  DetailViewController.m
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import "DetailViewController.h"
#import "MusicPlayerManage.h"
@interface DetailViewController ()
{
    MusicPlayerManage *manager;
    UISlider *slider;
    UILabel *leftLabel;
    UILabel *rightLabel;
    MusicModel *model;
    UIScrollView *scrollView;
    UILabel *singerLabel;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *声明一个播放器对象并创建一个model对象把选中的model赋给它
     */
    manager = [MusicPlayerManage defaultManager];
    model = manager.musicList[_musicIndex];
    manager.curIndex = _musicIndex;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.502 blue:0.000 alpha:1.000];
    /**
     展示图片的父视图滚动视图
     */
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 414, 736/3*2)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(414*model.desList.count, 0);
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    [self addImageView];
   
    /**
     显示有几张图片的视图，并且能通过它知道当前图片是第几张，默认一张时隐藏
     */
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(scrollView.frame), 414, 20)];
    page.numberOfPages = model.desList.count;
    page.hidesForSinglePage = YES;
    page.pageIndicatorTintColor = [UIColor blackColor];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:page];
    
    /**
     *  创建上一曲 播放 下一曲的按钮
     */
    for (int i = 0 ; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(65+90*i, 640, 80, 50);
        button.tag = 10+i;
        [button setBackgroundColor:[UIColor colorWithRed:0.502 green:0.251 blue:0.000 alpha:1.000]];
        button.layer.cornerRadius = 40;
        button.highlighted = YES;
        [self.view addSubview:button];
    }
    UIButton *button;
    button = [self.view viewWithTag:10];
    [button setTitle:@"上一曲" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backMusic:) forControlEvents:UIControlEventTouchDown];
    button = [self.view viewWithTag:11];
    [button setTitle:@"暂停" forState:UIControlStateNormal];
    [button setTitle:@"播放" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(currentplay:) forControlEvents:UIControlEventTouchDown];
    button = [self.view viewWithTag:12];
    [button setTitle:@"下一曲" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextMusic:) forControlEvents:UIControlEventTouchDown];
    /**
     显示音乐播放的进度
     */
    slider = [[UISlider alloc]initWithFrame:CGRectMake(80, 600, 414-160, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(moveTime:) forControlEvents:UIControlEventValueChanged];
    /**
     显示播放音乐的当前时间
     */
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 584, 60, 44)];
    [self.view addSubview:leftLabel];
    /**
     显示这首歌的总时间
     */
    rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(414-70, 584, 60, 44)];
    
    [self.view addSubview:rightLabel];
    /**
     *  选择播放顺序
     */
    UIButton *Shunxubutton = [UIButton buttonWithType:UIButtonTypeCustom];
    Shunxubutton.frame = CGRectMake(150, 695, 100, 736-695);
    [Shunxubutton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchDown];
    Shunxubutton.layer.cornerRadius = 20;
    [Shunxubutton setBackgroundColor:[UIColor colorWithRed:1.000 green:0.800 blue:0.400 alpha:1.000]];
    [Shunxubutton setTitle:@"顺序" forState:UIControlStateNormal];
    [self.view addSubview:Shunxubutton];
}
-(void)move{
    
    CGPoint myCenter = singerLabel.center;
    [UIView animateWithDuration:3 animations:^{
        singerLabel.center = CGPointMake(414-105,myCenter.y);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            singerLabel.center = myCenter;
        }];
    }];
    
}
-(void)changeType:(UIButton *)sender{
    static int index=0;
    index++;
    NSArray *titles = @[@"顺序",@"随机",@"<1>"];
    index = index>=titles.count?0:index;
    [sender setTitle:titles[index] forState:UIControlStateNormal];
    manager.loopType = index;
   [UIView animateWithDuration:0.5 animations:^{
       sender.transform = CGAffineTransformMakeScale(0.8,0.8);
   } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.7 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.1,1.1);
    }];
   }];
}
/**
 *  滑动白点改变播放的进程
 */
-(void)moveTime:(UISlider *)sli{
    manager.curTime = sli.value;

}
/**
 *  上一曲响应事件
 */
-(void)backMusic:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.transform = CGAffineTransformMakeScale(1.5, 1.5);
        sender.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            sender.alpha = 1.0;
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    UIButton *but = [self.view viewWithTag:11];
    but.selected = NO;
    [singerLabel removeFromSuperview];
    [manager back];
    model = manager.musicList[manager.curIndex];
    [self addImageView];
    [self upDateTimeWithProgress:manager.curIndex];
    [self move];
    
}
/**
 *  判断是播放还是暂停的响应事件
 */
-(void)currentplay:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.transform = CGAffineTransformMakeRotation(180*M_PI/180);
        sender.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            sender.alpha = 1.0;
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    sender.selected = !sender.selected;
    sender.selected == YES ? [manager pause]:[manager play];
    
}
/**
 *  下一曲响应事件
 */
-(void)nextMusic:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        
        sender.transform = CGAffineTransformMakeScale(0.5, 0.5);
        sender.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            
            sender.alpha = 1.0;
            sender.transform = CGAffineTransformIdentity;
        }];
    }];
    UIButton *but = [self.view viewWithTag:11];
    but.selected = NO;
    [manager next];
    [singerLabel removeFromSuperview];
    
    model = manager.musicList[manager.curIndex];
    [self addImageView];
    [self upDateTimeWithProgress:manager.curIndex];
    [self move];
}
/**
 图片视图
 */
-(void)addImageView{
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    for (int i = 0 ; i < model.desList.count; i++ ) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(414*i, 0, 414, 736/3*2)];
        imageView.image = [UIImage imageNamed:model.desList[i]];
        [scrollView addSubview:imageView];
    }
    /**
     *  显示歌名与歌手
     */
    singerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 736/3*2+40, 200, 50)];
    singerLabel.backgroundColor = [UIColor lightGrayColor];
    singerLabel.text = [NSString stringWithFormat:@"%@-%@",model.singer,model.music];
    [self.view addSubview:singerLabel];
  
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self upDateTimeWithProgress:self.musicIndex];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self move];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[MusicPlayerManage defaultManager] stop];
}
/**
 *  更新时间和进度
 */
-(void)upDateTimeWithProgress:(NSInteger )Index{
    [manager playMusicWithIndex:Index];
    __weak UILabel *lable = leftLabel;
        manager.curPlayTime = ^(NSString  *curPlayTime){
        lable.text = curPlayTime;
        };
    __weak UISlider *musicSlider = slider;
    manager.progress =^(float progress){
        musicSlider.value = progress;
    };
    rightLabel.text = manager.allPlayTime;
}
     
     
     
@end



