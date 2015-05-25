//
//  Dividend.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/24/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dividend : NSObject

@property (copy, nonatomic) NSString *ticker;
@property (nonatomic) double amountPerShare;
@property (strong, nonatomic) NSDate *date;

@end
