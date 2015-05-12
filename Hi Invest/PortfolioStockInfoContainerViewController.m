//
//  PortfolioStockInfoContainerViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioStockInfoContainerViewController.h"
#import "PortfolioStockInfoViewController.h"
#import "InvestingGame.h"
#import "Price.h"

@interface PortfolioStockInfoContainerViewController ()

@property (strong, nonatomic) PortfolioStockInfoViewController *portfolioStockInfoViewController;

@end

@implementation PortfolioStockInfoContainerViewController

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



















@end
