//
//  AppDelegate.m
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 12/9/14.
//  Copyright (c) 2014 Villou. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "ManagedObjectContextCreator.h"
#import "OpeningDatabaseFileKeys.h"
#import "UserDefaultsKeys.h"
#import "DefaultColors.h"


@interface AppDelegate ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [self setDefaultUIColors];
    
    [self setDefaultSettings];
    
    return YES;
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

// Set the default settings for the application, or the user configuration from previous launches.
- (void)setDefaultSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults doubleForKey:SettingsInitialCashKey]) {
        [defaults setDouble:SettingsDefaultInitialCash forKey:SettingsInitialCashKey];
    }
}
































@end
