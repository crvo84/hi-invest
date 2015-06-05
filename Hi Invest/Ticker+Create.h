//
//  Ticker+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Ticker.h"
#import "GameInfo.h"

@interface Ticker (Create)

+ (Ticker *)tickerWithGameInfo:(GameInfo *)gameInfo
                 realTickerStr:(NSString *)realTickerStr
                      UITicker:(NSString *)UITicker
                        UIName:(NSString *)UIName
             UIPriceMultiplier:(double)UIPriceMultiplier;

@end
