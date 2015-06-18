//
//  AppDelegate.m
//  MyWeibo
//
//  Created by focinfi on 15/5/19.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDatabase.h"
#import "MyWeiApp.h"
#import "SVProgressHUD.h"
#import "ImageModel.h"
#import "MomentModel.h"
#import "UserModel.h"
#import "MyWeiboDefaults.h"
#import "Random.h"
#import "NSString+Format.h"
#import "NSArray+Assemble.h"
#import "CocoaLumberjack.h"
#import "AVOSCloud.h"
#import "LoginViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setConfig];
    [self setBasicDataInitialization];
    [self test];
    return YES;
}

#pragma mark Test
- (void) test
{
//    test iamges
//    "moment_id" = 84
//    DBManager *manager = [MyWeiApp sharedManager].dbManager;
//    NSArray *images =
//        [manager arrayOfAllBySelect:[ImageModel arrayOfProperties]
//                     fromTable:[ImageModel stringOfTableName]
//                         where:nil];
//    NSLog(@"Images All:%@", images);
//    
////    MomentModel *moment = [MomentModel momentWithRandomValues];
////    DDLogDebug(@"Images:moment_id:%@", moment.momentID);
////    ImageModel *image = moment.images[1];
////    DDLogDebug(@"Images:%@", image.momentID);
//    
//    //test AVOS
//    MomentModel *moment = [MomentModel momentWithRandomValues];
//    [moment save];
    
    // block
    NSArray *nums = [NSArray arrayWithObjects:@1, @2, @3, @4, nil];
    DDLogDebug(@"Nums: %@", nums);
    NSString *s = @"s";
    NSArray *double_nums = [nums arrayByMap:(id)^(id item){
        return [NSString stringWithFormat:@"%@_%@", item, s];
    }];
    
    DDLogDebug(@"Nums Double: %@", double_nums);    
    
}

#pragma mark Configration

- (void) setConfig
{
    [self setUIColor];
    [self setCocoaLumberjack];
    [self setAVOS];
}

- (void) setUIColor
{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.90 alpha:1]];
}

- (void) setCocoaLumberjack
{
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // And we also enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (void) setAVOS
{
    [AVOSCloud setApplicationId:@"gmc220p5ceyvbglo41g9hwmdbscozebzxb1sfv90g70kl5ao"
                      clientKey:@"uje08oymkepwz8k2dvc2thq97dmj0msqr0bgvg4wl7ulc2te"];
}

#pragma mark DB Connection Init

- (void) setBasicDataInitialization
{
    DBManager *manager = [MyWeiApp sharedManager].dbManager;
    
    //create tables
    [manager createTableName:UserTableName columns:[UserModel directoryOfPropertiesAndTypes]];
    
    [manager createTableName:ImageTableName columns:[ImageModel directoryOfPropertiesAndTypes]];
    
    [manager createTableName:MomentTableName columns:[MomentModel directoryOfPropertiesAndTypes]];
}

#pragma mark Set UIViews

- (void) showLoginView
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    self.window.rootViewController = loginViewController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
