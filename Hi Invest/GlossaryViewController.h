//
//  GlossaryViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAccount;

@interface GlossaryViewController : UIViewController

@property (strong, nonatomic) UserAccount *userAccount;
@property (copy, nonatomic) NSString *glossaryId;

@end
