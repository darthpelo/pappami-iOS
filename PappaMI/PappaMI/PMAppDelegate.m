//
//  PMAppDelegate.m
//  PappaMI
//
//  Created by Alessio Roberto on 26/06/13.
//

#import "PMAppDelegate.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import "Crittercism.h"

@implementation PMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [NewRelicAgent startWithApplicationToken:@"AA81a1033ff6ed41d73d6697305c1a3731db9ec945"];
    [Crittercism enableWithAppID:@"51ddd7b1c463c24d70000005"];
    
    [NSUserDefaults resetStandardUserDefaults];
    NSString *dateKey = @"Data Key";
    NSDate *lastRead = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (!lastRead) {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
