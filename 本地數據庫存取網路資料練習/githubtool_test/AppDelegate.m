//
//  AppDelegate.m
//  githubtool_test
//
//  Created by ryan.huang on 2020/5/5.
//  Copyright © 2020 ryan.huang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TestViewController.h"
#import "SQL_test_ViewController.h"
#import "LocalLoadDataTestViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    ViewController *rootVC = [[ViewController alloc] init];
//    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:rootVC];
//
//    self.window.rootViewController = rootNAV;
//    [self.window makeKeyAndVisible];
    
//    TestViewController *rootVC = [[TestViewController alloc] init];
//    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:rootVC];
//
//    self.window.rootViewController = rootNAV;
//    [self.window makeKeyAndVisible];
    
//    SQL_test_ViewController *rootVC = [[SQL_test_ViewController alloc] init];
//    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:rootVC];
//
//    self.window.rootViewController = rootNAV;
//    [self.window makeKeyAndVisible];
    
    LocalLoadDataTestViewController *rootVC = [[LocalLoadDataTestViewController alloc] init];
    UINavigationController *rootNAV = [[UINavigationController alloc] initWithRootViewController:rootVC];

    self.window.rootViewController = rootNAV;
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
