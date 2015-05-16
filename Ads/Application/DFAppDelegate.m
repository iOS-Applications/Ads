//
//  AppDelegate.m
//  Ads
//
//  Created by zhudf on 15/4/14.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFAppDelegate.h"
#import "DFMainViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <UMengAnalytics/MobClick.h>

@interface DFAppDelegate ()

@end

@implementation DFAppDelegate

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 全局设置
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:222.0f green:222.0f blue:222.0f alpha:0]];
//    
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:10/225.0 green:10/222.0 blue:10/225.0 alpha:0]];
//    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    
    
    // test
//    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0]];
//    [[UINavigationBar appearance] setTitleTextAttributes:nil];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:nil forState:UIControlStateNormal];
    
    DFMainViewController *mainViewController = [[DFMainViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self.window makeKeyAndVisible];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 是否允许NSLocalNotification
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }
    
    [self setUpUMengAnalytis];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"%@", @"applicationDidRegisterUserNotificationSettings");
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [self addLocalNotification];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@", @"applicationDidReceiveLocalNotification");
    NSLog(@"%@", notification.userInfo);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%@", @"applicationWillEnterForeground");
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark -

- (void)addLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    notification.repeatInterval = kCFCalendarUnitDay;
    
    notification.alertLaunchImage = @"image_animal_1";
    
    notification.alertTitle = @"Title";
    notification.alertBody  = @"Body";  // 如果没设置alertBody就不会显示了
    notification.alertAction= @"Action";
    
    notification.soundName  = UILocalNotificationDefaultSoundName;
    
    notification.userInfo   = @{@"name" :@"zhudongfang",
                                @"age"  :@26};
    
    notification.applicationIconBadgeNumber++;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    //    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark 友盟统计
- (void)setUpUMengAnalytis {
    [MobClick startWithAppkey:@"555611f167e58e6637005df0" reportPolicy:BATCH channelId:@"AppStore"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setCrashReportEnabled:YES];
}
@end
