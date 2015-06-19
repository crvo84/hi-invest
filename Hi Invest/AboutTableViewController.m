//
//  AboutTableViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hiInvestImageView;
@property (weak, nonatomic) IBOutlet UIImageView *villouImageView;

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hi Invest Image View Setup
    self.hiInvestImageView.layer.cornerRadius = 8;
    self.hiInvestImageView.layer.masksToBounds = YES;
    
    // Villou Image View Setup
    self.villouImageView.layer.cornerRadius = 8;
    self.villouImageView.layer.masksToBounds = YES;
}

- (IBAction)openVillouLinkInSafari:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://villou.com"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"Failed to open url:%@",[url description]);
    }
}

@end
