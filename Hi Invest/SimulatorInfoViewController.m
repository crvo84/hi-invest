//
//  SimulatorInfoViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SimulatorInfoViewController.h"
#import "InfoPageContentViewController.h"
#import "Scenario.h"
#import "InvestingGame.h"
#import "SpeechBubbleView.h"
#import "DefaultColors.h"

@interface SimulatorInfoViewController () <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *scenarioLabel;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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
//    self.subview.layer.cornerRadius = 8;
//    self.subview.layer.masksToBounds = YES;
//    self.subview.layer.borderWidth = [DefaultColors speechBubbleBorderWidth];
//    self.subview.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.subview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    /* INFO VIEW */
    
    /* IMAGE VIEW */
    NSArray *imageNameSuffixes = @[@"D", @"E", @"H"];
    NSInteger suffixIndex = arc4random() % [imageNameSuffixes count];
    NSString *imageName = [NSString stringWithFormat:@"ninja%@", imageNameSuffixes[suffixIndex]];
    self.imageView.image = [UIImage imageNamed:imageName];
    
    [self infoPageViewControllerInitialSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI]; // Updating UI is done here to update when switching tabs
}

- (void)infoPageViewControllerInitialSetup
{
    
    self.infoPagesCount = 3; // MUST BE UPDATED IF MORE PAGES ARE ADDED
    
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
    self.scenarioLabel.text = [self.game.scenario.name uppercaseString];
    
    UIViewController *viewController = [self.infoPageViewController.viewControllers firstObject];
    if (viewController && [viewController respondsToSelector:@selector(updateUI)]) {
        [viewController performSelector:@selector(updateUI)];
    }
}


//// Sets the text to the speech text view without losing the attributes from interface builder
//// To show animation, there MUST be some preloaded text from interface builder to get the attributes
//- (void)setTextViewWithString:(NSString *)str withTextAlignment:(NSTextAlignment)textAlignment animated:(BOOL)animated
//{
//    UIFont *font = [UIFont systemFontOfSize:[DefaultColors speechBubbleTextViewFontSize]];
//    UIColor *textColor = [DefaultColors speechBubbleTextViewTextColor];
//    
//    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : textColor};
//    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
//    
//    if (animated) {
//        [UIView animateWithDuration:0.1 animations:^{
//            self.textView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            self.textView.attributedText = attributedStr;
//            self.textView.textAlignment = textAlignment;
//            [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
//            [UIView animateWithDuration:0.25 animations:^{
//                self.textView.alpha = 1.0;
//            }];
//        }];
//    } else {
//        self.textView.attributedText = attributedStr;
//    }
//    
//}

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



















@end
