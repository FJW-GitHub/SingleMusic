//
//  DetailViewController.h
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  播放音乐的视图控制器
 */
@interface DetailViewController : UIViewController
@property (nonatomic,assign) NSInteger musicIndex;//点击的那个cell 改播放哪首音乐

-(void)addImageView;//显示歌手的图片
@end
