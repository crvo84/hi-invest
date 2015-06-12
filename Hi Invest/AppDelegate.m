//
//  AppDelegate.m
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 12/9/14.
//  Copyright (c) 2014 Villou. All rights reserved.
//

#import "AppDelegate.h"
#import "DefaultColors.h"

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setDefaultUIColors];
    
    // [Optional] Power your app with Local Datastore.
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"VfZRAhhGl9MJKKv00RUflxktEF239YU0L6o8YZOv"
                  clientKey:@"6rgd31HkXftA0bgRtRj7H8G9GWV87ecHKmMdxnRG"];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
//    return YES;
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
































// Set the default UI colors
- (void)setDefaultUIColors
{
//    self.window.backgroundColor = [DefaultColors windowBackgroundColor];
    self.window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    [[UINavigationBar appearance] setBarTintColor:[DefaultColors navigationBarColor]];
    [[UINavigationBar appearance] setTintColor:[DefaultColors navigationBarButtonColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [DefaultColors navigationBarTitleColor]}];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    [[UITabBar appearance] setTranslucent:NO];
    
    UIColor *elementColor = [DefaultColors UIElementsBackgroundColor];
    [[UISegmentedControl appearance] setTintColor:elementColor];
    [[UISegmentedControl appearance] setAlpha:[DefaultColors UIElementsBackgroundAlpha]];
    [[UISlider appearance] setTintColor:elementColor];
    [[UISlider appearance] setAlpha:[DefaultColors UIElementsBackgroundAlpha]];
    
    [[UITableViewCell appearance] setBackgroundColor:[DefaultColors tableViewCellBackgroundColor]];
    
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor darkGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor lightGrayColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



@end
