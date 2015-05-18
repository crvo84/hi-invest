//
//  PortfolioStockInfoContainerViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioStockInfoContainerViewController.h"
#import "PortfolioStockInfoViewController.h"
#import "DefaultColors.h"
#import "InvestingGame.h"
#import "Price.h"

@interface PortfolioStockInfoContainerViewController ()

@property (strong, nonatomic) PortfolioStockInfoViewController *portfolioStockInfoViewController;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation PortfolioStockInfoContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Set rounded corners for pickerView
    self.container.layer.cornerRadius = 8; // Magic number
    self.container.layer.masksToBounds = YES;
}

#pragma mark - Setters

- (void)setTicker:(NSString *)ticker
{
    _ticker = ticker;
    
    if (self.portfolioStockInfoViewController) {
        // In case "Prepare For Segue" was called before ticker setter
        self.portfolioStockInfoViewController.ticker = ticker;
    }
}

- (void)setGame:(InvestingGame *)game
{
    _game = game;
    
    if (self.portfolioStockInfoViewController) {
        // In case "Prepare For Segue" was called before game setter
        self.portfolioStockInfoViewController.game = game;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
      //---------------------------------------------------/
     /* Portfolio Stock Info View Controller Embed Segue */
    //---------------------------------------------------/
    if ([segue.identifier isEqualToString:@"Embedded PortfolioStockInfoViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[PortfolioStockInfoViewController class]]) {
            // We save a link to the destination view controller in case "Prepare for Segue" is called before price setter.
            self.portfolioStockInfoViewController = segue.destinationViewController;
            if (self.ticker && self.game) {
                // In case price and game setters were called before "Prepare for segue".
                [self preparePortfolioStockInfoViewController:self.portfolioStockInfoViewController withTicker:self.ticker andInvestingGame:self.game];
            }
        }
    }
    
}

- (void)preparePortfolioStockInfoViewController:(PortfolioStockInfoViewController *)portfolioStockInfoViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    portfolioStockInfoViewController.ticker = ticker;
    portfolioStockInfoViewController.game = game;
}

// Exit View Controller when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

















@end
