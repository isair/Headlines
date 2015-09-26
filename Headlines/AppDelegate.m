//
//  AppDelegate.m
//  Headlines
//
//  Created by Baldrick
//  Copyright © 2015 Buy n Large. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "ArticleGalleryViewController.h"
#import <MagicalRecord/MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIButton appearance].tintColor = AppConfig.primaryColor;
    [UINavigationBar appearance].tintColor = AppConfig.primaryColor;

    [MagicalRecord setupCoreDataStack];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ArticleGalleryViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end
