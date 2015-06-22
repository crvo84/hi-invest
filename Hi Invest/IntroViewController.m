//
//  IntroViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/22/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroPageContentViewController.h"
#import "DefaultColors.h"
#import "UserAccount.h"

@interface IntroViewController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIView *backgroundSubview;
@property (weak, nonatomic) IBOutlet UIView *introSubview;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *ninjaImageView;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSUInteger pageIndex;
@property (nonatomic) NSUInteger pagesCount;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View Setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Background Subview Setup
    self.backgroundSubview.layer.cornerRadius = 8;
    self.backgroundSubview.layer.masksToBounds = YES;
    
    // Intro Subview Setup
    self.introSubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // Ninja Image View Setup
    [self.ninjaImageView setImage:[UIImage imageNamed:@"ninjaD"]];
    
    [self pageViewControllerInitialSetup];
}

- (void)pageViewControllerInitialSetup
{
    
    self.pagesCount = 3; // MUST BE UPDATED IF MORE PAGES ARE ADDED
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageViewController"];
    self.pageViewController.dataSource = self;
    
    IntroPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.introSubview.frame.size.width, self.introSubview.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.introSubview addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - UIPageViewController Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    NSUInteger newIndex;
    if (index == 0) {
        newIndex = self.pagesCount - 1;
    } else {
        newIndex = index - 1;
    }
    
    return [self viewControllerAtIndex:newIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((IntroPageContentViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    NSUInteger newIndex;
    if (index == self.pagesCount - 1) {
        newIndex = 0;
    } else {
        newIndex = index + 1;
    }
    
    return [self viewControllerAtIndex:newIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.pagesCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

/* Page View Controller Data Source HELPER METHODS */

- (IntroPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((self.pagesCount == 0) || (index >= self.pagesCount)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    IntroPageContentViewController *introPageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroPageContentViewController"];
    introPageContentViewController.pageIndex = index;
    introPageContentViewController.userName = [self.userAccount userName];
    
    return introPageContentViewController;
}


#pragma mark - Navigation

// Exit View Controller when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view || viewTouched == self.imageBackgroundView || viewTouched == self.ninjaImageView) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}





@end
