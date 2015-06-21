//
//  UserAccountViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAccount;
@class SKProduct;

@interface UserAccountViewController : UIViewController

@property (strong, nonatomic) UserAccount *userAccount;

- (void)purchaseSelectedProduct;

- (void)restore;


@end
