//
//  InitialViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "InitialViewController.h"
#import "UserDefaultsKeys.h"
#import "ManagedObjectContextCreator.h"
#import "InvestingGame.h"
#import "CompaniesViewController.h"
#import "PortfolioTableViewController.h"
#import "SideMenuRootViewController.h"
#import "Scenario.h"

@interface InitialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *subviewButtons;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (nonatomic) BOOL appJustLaunched;

@property (nonatomic) CGRect originalLogoImageViewFrame;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.startGameButton.layer.cornerRadius = 8;
    self.startGameButton.layer.masksToBounds = YES;
    
    self.appJustLaunched = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    if (self.appJustLaunched) {
        self.logoImageView.alpha = 0.0;
        self.nameLabel.alpha = 0.0;
        self.startGameButton.alpha = 0.0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.appJustLaunched) {
        [self presentLogoWithAnimation];
    }
    
    self.appJustLaunched = NO;
}

- (void)presentLogoWithAnimation
{
    
    CGRect originalLogoFrame = self.logoImageView.frame;

    // Starting biggest frame
    CGFloat startingLogoX = self.view.frame.origin.x - self.view.frame.size.width / 2;
    CGFloat startingLogoY = self.view.frame.origin.y - self.view.frame.size.height / 2;
    CGFloat startingLogoWidth = self.view.frame.size.width * 2;
    CGFloat startingLogoHeight = self.view.frame.size.height * 2;
    CGRect startingFrame = CGRectMake(startingLogoX, startingLogoY, startingLogoWidth, startingLogoHeight);

    // Centered big frame
    CGFloat centeredLogoX = self.view.frame.size.width / 2 - originalLogoFrame.size.width / 2;
    CGFloat centeredLogoY = self.view.frame.size.height / 2 - originalLogoFrame.size.height / 2;
    CGFloat centeredLogoWidth = originalLogoFrame.size.width;
    CGFloat centeredLogoHeight = originalLogoFrame.size.height;
    CGRect centeredFrame = CGRectMake(centeredLogoX, centeredLogoY, centeredLogoWidth, centeredLogoHeight);
    
    self.logoImageView.frame = startingFrame;

//    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.logoImageView.frame = centeredFrame;
        self.logoImageView.alpha = 1.0;
        [self runSpinAnimationOnView:self.logoImageView duration:3.0 rotations:1.0 repeat:1.0];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
                self.logoImageView.frame = originalLogoFrame;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
                    self.nameLabel.alpha = 1.0;
                    self.startGameButton.alpha = 1.0;
                } completion:nil];
        }];
    }];
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    InvestingGame *game = [self createNewInvestingGame];
//    
//    if ([segue.destinationViewController isKindOfClass:[SideMenuRootViewController class]]) {
//        ((SideMenuRootViewController *)segue.destinationViewController).game = game;
//    }
//}

- (InvestingGame *)createNewInvestingGame;
{
    NSManagedObjectContext *context = [ManagedObjectContextCreator createMainQueueManagedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scenario"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        
        NSLog(@"Error fetching Scenario from database");
        
    } else if ([matches count] == 0) {
        
        NSLog(@"No Scenario in database");
        
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        double initialCash = [defaults doubleForKey:SettingsInitialCashKey];
        Scenario *scenario = [matches firstObject];
        return [[InvestingGame alloc] initInvestingGameWithInitialCash:initialCash scenario:scenario andPortfolioPictures:nil];
        
    }
    
    return nil;
}

#pragma mark - Unwind Segues

- (IBAction)unwindToInitialViewController:(UIStoryboardSegue *)unwindSegue
{
    
}













@end
