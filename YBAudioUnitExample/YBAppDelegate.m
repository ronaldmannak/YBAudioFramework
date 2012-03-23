//
//  YBAppDelegate.m
//  YBAudioUnitExample
//
//  Created by Martijn Thé on 3/21/12.
//  Copyright (c) 2012 Yobble. All rights reserved.
//

#import "YBAppDelegate.h"

#import "YBViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation YBAppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[YBViewController alloc] initWithNibName:@"YBViewController" bundle:nil]];
    
    // Override point for customization after application launch.
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
