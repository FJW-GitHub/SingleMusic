//
//  ViewController.m
//  SingleMusic
//
//  Created by xiaofu on 16/3/17.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import "ViewController.h"
#import "MusicPlayerManage.h"
#import "DetailViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 000, 414, 736) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [super viewDidLoad];
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MusicPlayerManage defaultManager].musicList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"110";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//右侧有个箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MusicModel *model = [MusicPlayerManage defaultManager].musicList[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:model.singerIcon];
    cell.textLabel.text = model.singer;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame)/3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detatil = [[DetailViewController alloc]init];
    detatil.musicIndex = indexPath.row;
    
    [self presentViewController:detatil animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
