//
//  gepu.m
//  诗歌本恩泉
//
//  Created by Ru on 19/5/16.
//  Copyright © 2016年 Ru. All rights reserved.
//

#import "gepu.h"

@implementation gepu


- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


+ (instancetype)puWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}


+ (NSArray *)gepuList
{
    NSString *gepuPath = [[NSBundle mainBundle]pathForResource:@"gepu.plist" ofType:nil];
    NSArray *gepuDictArray = [NSArray arrayWithContentsOfFile:gepuPath];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in gepuDictArray) {
        [tempArray addObject:[gepu puWithDict:dict]];
    }
    return tempArray;
}

@end
