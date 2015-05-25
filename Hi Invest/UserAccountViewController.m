//
//  UserAccountViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccountViewController.h"
#import "UserAccount.h"

@interface UserAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;

@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level: %ld", (long)[self.userAccount userLevel]];
}



@end
