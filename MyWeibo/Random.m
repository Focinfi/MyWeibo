//
//  Random.m
//  MyWeibo
//
//  Created by focinfi on 15/5/23.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "Random.h"
#import "NSArray+Assemble.h"

@implementation Random

+ (BOOL) possibilityTenOfNum:(int)num
{
    if (arc4random() % 10 < num) {
        return YES;
    } else {
        return NO;
    }
}

+ (int) randZeroToNum:(int)num
{
    return arc4random() % num;
}

+ (NSString *) stringOfRandomWeibo:(int)length
{
    NSArray *weiboArray = [NSArray arrayWithObjects:
                           @"我生君未生，君生我已老，我恨君生迟，君恨我生早。错过的感觉真的很不好。",
                           @"#Dr.伦太郎# 第二集 夢乃小妖精【GIF】合集 快來看蒼井優變臉神技！#說你不是精分官皮自己都不信！# 一個日野倫倒下 無數個元能寺站起來！錢都不事兒！統統給你。",
                           @"坐在校道边的座椅上 听到身旁的教学楼里有人放熊杏木里的歌 三年前的时候几乎整个歌表都是她三年前，我在想什么呢？",
                           @"这是追逐繁星的孩子里面那个画面？我还记得片尾曲熊杏木里唱的hello goodbye hello 相遇离别重逢。",nil];

    NSMutableArray *weibos= [NSMutableArray array];
    int rand = [Random randZeroToNum:(int)weiboArray.count];
    for (int i = rand; weibos.count <= length; i = i + [Random randZeroToNum:2]) {
        i = i % weiboArray.count;
        [weibos addObject:weiboArray[i]];
        
    }
    
    return [weibos joinWithBoundary:@" "];
}

@end
