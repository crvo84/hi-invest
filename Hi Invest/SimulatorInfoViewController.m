//
//  SimulatorInfoViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SimulatorInfoViewController.h"
#import "InfoPageContentViewController.h"
#import "UserAccount.h"
#import "GameInfo.h"
#import "InvestingGame.h"
#import "SpeechBubbleView.h"
#import "DefaultColors.h"

@interface SimulatorInfoViewController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UIView *subsubview; // for background color
@property (weak, nonatomic) IBOutlet UILabel *scenarioLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) UIPageViewController *infoPageViewController;
@property (nonatomic) NSUInteger infoIndex;
@property (nonatomic) NSUInteger infoPagesCount;

@end

@implementation SimulatorInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* VIEW */
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    /* SUBVIEW */
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
    
    /* SUBSUBVIEW */
    self.subsubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    /* RESTART BUTTON */
    UIImage *restartImage = [[UIImage imageNamed:@"restart30x30"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.restartButton setImage:restartImage forState:UIControlStateNormal];
    [self.restartButton setTintColor:[DefaultColors buttonDefaultColor]];
    
    [self infoPageViewControllerInitialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI]; // Updating UI is done here to update when switching tabs
}

- (void)infoPageViewControllerInitialSetup
{
    
    self.infoPagesCount = 2; // MUST BE UPDATED IF MORE PAGES ARE ADDED
    
    // Create page view controller
    self.infoPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPageViewController"];
    self.infoPageViewController.dataSource = self;
    
    InfoPageContentViewController *startingInfoViewController = [self infoViewControllerAtIndex:0];
    NSArray *infoViewControllers = @[startingInfoViewController];
    [self.infoPageViewController setViewControllers:infoViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.infoPageViewController.view.frame = CGRectMake(0, 0, self.infoView.frame.size.width, self.infoView.frame.size.height);
    
    [self addChildViewController:_infoPageViewController];
    [self.infoView addSubview:_infoPageViewController.view];
    [self.infoPageViewController didMoveToParentViewController:self];
}


#pragma mark - Updating UI and Data

- (void)updateUI
{
    GameInfo *gameInfo = self.game.gameInfo;
    
    self.scenarioLabel.text = [gameInfo.scenarioName uppercaseString];
    
    self.restartButton.hidden = [gameInfo.currentDay integerValue] < [gameInfo.numberOfDays integerValue];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = self.game.locale;
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    if ([gameInfo.finished boolValue]) {
        self.daysLabel.text = @"Finished";
        
    } else {
        NSString *currentDayStr = [numberFormatter stringFromNumber:gameInfo.currentDay];
        self.daysLabel.text = [NSString stringWithFormat:@"Day %@", currentDayStr];
    }
    
    UIViewController *viewController = [self.infoPageViewController.viewControllers firstObject];
    if (viewController && [viewController respondsToSelector:@selector(updateUI)]) {
        [viewController performSelector:@selector(updateUI)];
    }
}


#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InfoPageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    NSUInteger newIndex;
    if (index == 0) {
        newIndex = self.infoPagesCount - 1;
    } else {
        newIndex = index - 1;
    }
    
    return [self infoViewControllerAtIndex:newIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((InfoPageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    NSUInteger newIndex;
    if (index == self.infoPagesCount - 1) {
        newIndex = 0;
    } else {
        newIndex = index + 1;
    }
    
    return [self infoViewControllerAtIndex:newIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.infoPagesCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

/* Page View Controller Data Source HELPER METHODS */

- (InfoPageContentViewController *)infoViewControllerAtIndex:(NSUInteger)index
{
    if ((self.infoPagesCount == 0) || (index >= self.infoPagesCount)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    InfoPageContentViewController *infoPageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoPageContentViewController"];
    infoPageContentViewController.game = self.game;
    infoPageContentViewController.pageIndex = index;
    
    return infoPageContentViewController;
}

#pragma mark - Navigation

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self dismissViewController];
    }
}

- (IBAction)dismissViewController
{
    [self performSegueWithIdentifier:@"unwindToSideMenuRootViewController" sender:self];
}


- (IBAction)startAgainButtonPressed
{
    [self performSegueWithIdentifier:@"Reset Game" sender:self];
}














@end
