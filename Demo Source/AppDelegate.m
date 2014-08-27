//
//  AppDelegate.m
//  JBAnimation
//
//  Created by Joel Bernstein on 6/19/14.
//  Copyright (c) 2014 Joel Bernstein. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()
            

@end



@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

@end
