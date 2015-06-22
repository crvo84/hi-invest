//
//  IntroPageContentViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/22/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "IntroPageContentViewController.h"
#import "ParseUserKeys.h"

@interface IntroPageContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation IntroPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.pageIndex == 0) {

        self.textLabel.text = [NSString stringWithFormat:@"Hello %@,\nWelcome to Hi Invest!", self.userName];
        
    } else if (self.pageIndex == 1) {
        self.textLabel.text = @"Stock market simulator with real historical data!";
        
    } else if (self.pageIndex == 2) {
        self.textLabel.text = @"Become a financial analyst expert!";
        
    }
    
    self.textLabel.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.textLabel.alpha = 1.0;
    } completion:nil];
}





@end
