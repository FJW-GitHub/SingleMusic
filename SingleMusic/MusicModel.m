//
//  MusicModel.m
//  MYMusic
//
//  Created by xiaofu on 16/3/15.
//  Copyright © 2016年 xiaofu. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:info];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
