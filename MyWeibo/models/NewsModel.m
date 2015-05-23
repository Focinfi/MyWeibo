//
//  NewsModel.m
//  MyWeibo
//
//  Created by focinfi on 15/5/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "NewsModel.h"
#import "Random.h"

@implementation NewsModel

#pragma mark - Dictionary Format For NewsModel

+ (NSDictionary *) directoryForAtrributesAndTpyes
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    NSArray *types = [NSArray arrayWithObjects:@"TEXT", @"TEXT", @"TEXT", @"TEXT", @"TEXT", nil];
    return [NSDictionary dictionaryWithObjects: types forKeys: keys];
}

+ (NSDictionary *) directoryForAtrributesAndNames
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    return [NSDictionary dictionaryWithObjects: keys forKeys: keys];
}

+ (NewsModel *) newsWithRandomValues
{
    NewsModel *news = [[NewsModel alloc] init];

    news.weibo = [Random stringOfRandomWeibo:[Random randZeroToNum:3]];

    if ([Random possibilityTenOfNum:5]) {
        news.name = @"仓井优";
        news.desc = @"森系日本演员";
        if ([Random possibilityTenOfNum:5]) {
            news.avatar = @"Aoi1";
            news.weiboImage = @"weibo1";
        } else {
            news.avatar = @"Aoi2";
            news.weiboImage = @"weibo2";
        }
    } else {
        news.name = @"熊杏木里";
        news.desc = @"小清新歌手";
        if ([Random possibilityTenOfNum:5]) {
            news.avatar = @"Anri1";
            news.weiboImage = @"weibo1";
        } else {
            news.avatar = @"Anri2";
            news.weiboImage = @"weibo2";
        }
    }
        
    return news;
}

#pragma mark - Initialize

- (id) initNewsWithRandomValues
{
    self = [super init];
    if (self) {
        _name = @"熊杏木里";
        _avatar = @"Aino";
        _desc = @"小清新";
        _weibo = @"I am singing";
        _weiboImage = @"weibo2";

    }
    
    return self;
}

#pragma mark - Dictionary Form For Instance

- (NSDictionary *) dictionaryWithNewsPairs
{
    NSArray *keys = [NSArray arrayWithObjects:@"avatar", @"name", @"desc", @"weibo", @"weibo_image", nil];
    NSArray *types = [NSArray arrayWithObjects:_avatar, _name, _desc, _weibo, _weiboImage, nil];
    return [NSDictionary dictionaryWithObjects: types forKeys: keys];
}

@end
