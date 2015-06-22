
//
//  CommentModel.m
//  MyWeibo
//
//  Created by focinfi on 15/6/9.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "MomentModel.h"
#import "Random.h"
#import "MyWeiboDefaults.h"
#import "ImageModel.h"
#import "MyWeiApp.h"
#import "UserModel.h"
#import "NSArray+Assemble.h"
#import "NSDictionary+Assemble.h"
#import "NSString+Format.h"
#import "Support.h"

@implementation MomentModel
@synthesize momentID;
@synthesize userID;
@synthesize content;

#pragma mark - Construction

- (id)init
{
    self = [super init];
    if (self) {
        _images = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Class Methods Return Basic Data

+ (int)countOfMoments
{
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;

    return [dbManager countOfItemsNumberInTable:MomentTableName];
    
}

+ (NSArray *)arrayOfProperties
{
    return @[MomentID, UserID, MomentContent];
}

+ (NSDictionary *)directoryOfPropertiesAndTypes
{
    NSArray *types = @[@"TEXT", @"TEXT", @"TEXT"];
    return [NSDictionary dictionaryWithObjects:types forKeys:[MomentModel arrayOfProperties]];
}

+ (MomentModel *) momentWithRandomValues
{
    MomentModel *comment = [[MomentModel alloc] init];
    
    comment.userID = @"1";
    comment.content = [Random stringOfRandomWeiboSetencesCount:[Random randZeroToNum:3]];
    comment.momentID = [NSNumber numberWithInt:[[MyWeiboDefaults stringOfIdentifier:MomentID] intValue]];
    [comment addImageModelsNumber:[Random randZeroToNum:4] + 1];

    return comment;
}

#pragma mark - Get Data from Database

+ (NSArray *)arrayOfItemsFrom:(long) from to:(long) to
{
    NSMutableArray *data = [NSMutableArray array];
    DBManager *dbManager = [MyWeiApp sharedManager].dbManager;
    NSDictionary *orderDictionary = @{MomentID: DataBaseOrderDESC};

    NSArray *moments = [dbManager arrayBySelect:[MomentModel arrayOfProperties] fromTable:MomentTableName where:nil orderBy: orderDictionary from:from to:to];
    NSLog(@"Refresh Moments In MomentModel:%@", moments);
    for (NSDictionary *moment in moments) {
 
        NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) moment];
        //set images
        NSString *momentID = [item objectForKey:MomentID];
        NSArray *images =
            [dbManager
                arrayOfAllBySelect:@[ImageName]
                         fromTable:ImageTableName
                             where:[NSDictionary dictionaryWithObject:momentID forKey:MomentID]];
        
        images = [images arrayByMap:(id)^(id item) {
            return [item objectForKey:ImageName];
        }];
        
        NSMutableArray *imagesArray = [NSMutableArray arrayWithArray:images];
        NSLog(@"Refresh Moments id %@ Images%@", momentID, imagesArray);
        [item setObject:imagesArray forKey:ImageTableName];
        
        UserModel *user = [[UserModel alloc] init];
        if ([[MyWeiboDefaults stringOfKey:LoggedIn] isYES] &&
            [[MyWeiboDefaults stringOfKey:@"user_moment"] isYES]) {
            user.userID = [MyWeiboDefaults stringOfIdentifier:UserID];
            user.name = [MyWeiboDefaults stringOfKey:CurrentUser];
            user.avatar = @"Aoi1";
            user.desc = @"他很懒，什么都不说。";
        } else {
            user = [UserModel userWithRandomValues];
        }

        [item setObject:[user dictionaryOfPropertiesAndValues] forKey:MomentUser];
        
        [data addObject:item];
    }
    NSLog(@"Refresh Moments Data:%lu", [data count]);

    return data;
}

#pragma mark - Extrive Data From Objects

+ (NSDictionary *)dictionaryOfObject:(id) object
{
    NSMutableDictionary *momentDictionary = [NSMutableDictionary dictionary];
    [[MomentModel arrayOfProperties] excetueEach:^(id item){
        [momentDictionary setObject:[object objectForKey:item] forKey:item];
    }];
    
    if ([object objectForKey:ImageTableName]) {
        [momentDictionary setObject:[object objectForKey:ImageTableName] forKey:ImageTableName];
    }
    if ([object objectForKey:MomentUser]) {
        [momentDictionary setObject:[object objectForKey:MomentUser] forKey:MomentUser];
    }
    
    return momentDictionary;
}

+ (NSArray *)arrayOfObjects:(NSArray *) objects
{
    NSMutableArray *momentsAarry = [NSMutableArray array];
    [objects excetueEach:^(id item){
        [momentsAarry addObject:[MomentModel dictionaryOfObject:item]];
    }];
    return momentsAarry;
}

#pragma mark - Attributes Maker

- (void)addImageModelsNumber:(int) number
{
    int rand = [Random randZeroToNum:4];
    for (int i = 0; i < number; i++) {
        int identifier = (rand + i)%4 + 1;
        ImageModel *image = [ImageModel imageWithIdentifier: identifier
                                               ForCommentID:self.momentID];
        [self.images addObject:image];
    }
}

#pragma mark - Extrive Data From MomentModel Instance

- (NSDictionary *)dictionaryOfPropertiesAndValues
{
    return [NSDictionary dictionaryWithObjects:@[momentID, userID, content]
                                       forKeys:[MomentModel arrayOfProperties]];
}

- (NSArray *)arrayOfInsertSqls
{
    NSMutableArray *insertSqls = [NSMutableArray array];
    [insertSqls addObject:
     [Support stringOfInsertSqlWihtTableName:MomentTableName
                                     columns:self.dictionaryOfPropertiesAndValues]];
    
    for (ImageModel *image in self.images) {
        [insertSqls addObject:
         [Support stringOfInsertSqlWihtTableName:ImageTableName
                                         columns:image.dictionaryOfPropertiesAndValues]];
    }
    return insertSqls;
}

#pragma mark - Overwirte AVObject Methods

- (void)saveInBackgroundWithBlock:(AVBooleanResultBlock)block
{
    [[self dictionaryOfPropertiesAndValues] eachPairDo:^(NSString *key, id value) {
        [self setObject:value forKey:key];
    }];
    NSArray *imageNames = [self.images arrayByMap:(id)^(id image){
        ImageModel *i = image;
        return i.name;
    }];
    
    [self setObject:imageNames forKey:ImageTableName];
    UserModel *user = [UserModel userWithRandomValues];
    user.name = [MyWeiboDefaults stringOfKey:CurrentUser];
    user.avatar = [MyWeiboDefaults stringOfKey:UserAvatarImage];
    user.desc = [MyWeiboDefaults stringOfKey:UserDescription];
    [self setObject:[user dictionaryOfPropertiesAndValues] forKey:MomentUser];
    
    [super saveInBackgroundWithBlock:block];
}

@end
