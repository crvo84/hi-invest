//
//  CompanyDisguiseManager.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompanyDisguiseManager.h"
#import "Ticker+Create.h"
#import "GameInfo.h"

@interface CompanyDisguiseManager ()

@property (strong, nonatomic) NSMutableDictionary *tickersChanged; // @{ real ticker : fictional ticker NSString }
@property (strong, nonatomic) NSMutableDictionary *namesChanged; // @{ real ticker : fictional name NSString }
@property (strong, nonatomic) NSMutableDictionary *priceMultipliers; // @{ real ticker : @(price multiplier) double }

@end

@implementation CompanyDisguiseManager

#define FictionalNameCompanyTypes @[@"INC", @"CO", @"CORP"]

// Designated initializer
// Receive a GameInfo managed object, a NSArray of real Tickers to disguise and a NSDictionary mapping fictional names with fictional tickers @{name : ticker}
// If it is a new game generate new disguised info
// If it is an existing game, user existing info
- (instancetype)initWithGameInfo:(GameInfo *)gameInfo withCompanyRealTickers:(NSArray *)realTickers withFictionalNamesAndTickers:(NSDictionary *)fictionalNamesAndTickers
{
    self = [super init];
    
    if (self) {
        
        self.tickersChanged = [[NSMutableDictionary alloc] init];
        self.namesChanged = [[NSMutableDictionary alloc] init];
        self.priceMultipliers = [[NSMutableDictionary alloc] init];
        
        NSArray *tickersFromGameInfo = [gameInfo.tickers allObjects];
        if ([tickersFromGameInfo count] > 0) { // Existing game
            
            for (Ticker *ticker in tickersFromGameInfo) {
                NSString *realTicker = ticker.realTicker;
                self.tickersChanged[realTicker] = ticker.uiTicker;
                self.namesChanged[realTicker] = ticker.uiName;
                self.priceMultipliers[realTicker] = ticker.uiPriceMultiplier;
            }
            
        } else if ([tickersFromGameInfo count] == 0) { // New Game
            
            NSMutableArray *namesLeft = [[fictionalNamesAndTickers allKeys] mutableCopy];
            NSMutableSet *existingFictionalTickers = [[NSMutableSet alloc] init];
            
            for (NSString *realTicker in realTickers) {
                
                while ([namesLeft count] > 0) {
                    
                    
                    NSInteger randomNameIndex = arc4random() % [namesLeft count];
                    
                    NSString *fictionalName = namesLeft[randomNameIndex];
                    NSString *fictionalTicker = [fictionalNamesAndTickers[fictionalName] uppercaseString];
                    
                    [namesLeft removeObject:fictionalName];
                    
                    if ([existingFictionalTickers containsObject:fictionalTicker]) {
                        fictionalTicker = [self fictionalTickerForName:fictionalName notPresentInSet:existingFictionalTickers];
                    }
                    
                    if (fictionalTicker) {
                        [existingFictionalTickers addObject:fictionalTicker];
                        
                        NSInteger randomCompanyTypeIndex = arc4random() % [FictionalNameCompanyTypes count];
                        fictionalName = [[NSString stringWithFormat:@"%@ %@", fictionalName, FictionalNameCompanyTypes[randomCompanyTypeIndex]] uppercaseString];
                        
                        // Random NSUInteger greater than 1 to multiply prices
                        NSUInteger priceMultiplier = (arc4random() % 3) + 2;
                        
                        self.tickersChanged[realTicker] = fictionalTicker;
                        self.namesChanged[realTicker] = fictionalName;
                        self.priceMultipliers[realTicker] = @(priceMultiplier);
                        
                        [Ticker tickerWithGameInfo:gameInfo realTickerStr:realTicker UITicker:fictionalTicker UIName:fictionalName UIPriceMultiplier:priceMultiplier];
                        
                        break;
                    }
                }
            }
        }
    }
    
    return self;
}

#pragma mark - Public methods

- (NSString *)nameFromTicker:(NSString *)ticker
{
    return self.namesChanged[ticker];
}

- (NSString *)tickerFromTicker:(NSString *)ticker
{
    return self.tickersChanged[ticker];
}

- (NSUInteger)priceMultiplierFromTicker:(NSString *)ticker
{
    NSNumber *priceMultiplierNumber = self.priceMultipliers[ticker];
    
    if (!priceMultiplierNumber) {
        return NSNotFound;
    }
    
    return [priceMultiplierNumber unsignedIntegerValue];
}


#pragma mark - Random Info Generator

// Return a upper case 3 or 4 letter ticker generated from the given name, not included in the given set
// Return nil if ticker could not be generated.
- (NSString *)fictionalTickerForName:(NSString *)name notPresentInSet:(NSSet *)otherTickers
{
    // Remove all blank spaces and convert to all upercase
    NSString *lettersStr = [[name stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    
    if (lettersStr.length >= 3) {
        
        // A) All four characters
        if (lettersStr.length == 4) {
            NSString *tickerA = lettersStr;
            if (![otherTickers containsObject:tickerA]) {
                return tickerA;
            }
        }
        
        // B) First three characters
        NSString *tickerB = [lettersStr substringToIndex:3];
        if (![otherTickers containsObject:tickerB]) {
            return tickerB;
        }
        
        // C) First two character + last character
        NSString *tickerC = [NSString stringWithFormat:@"%@%@", [lettersStr substringToIndex:2], [lettersStr substringFromIndex:lettersStr.length - 1]];
        if (![otherTickers containsObject:tickerC]) {
            return tickerC;
        }
        
        // D) First character + last two characters
        NSString *tickerD = [NSString stringWithFormat:@"%@%@", [lettersStr substringToIndex:1], [lettersStr substringFromIndex:lettersStr.length - 2]];
        if (![otherTickers containsObject:tickerD]) {
            return tickerD;
        }
        
        // E) B, C or D with double initial letter
        NSString *tickerE = [NSString stringWithFormat:@"%@%@", [tickerB substringToIndex:1], tickerB];
        if (![otherTickers containsObject:tickerE]) {
            return tickerE;
        }
        tickerE = [NSString stringWithFormat:@"%@%@", [tickerC substringToIndex:1], tickerC];
        if (![otherTickers containsObject:tickerE]) {
            return tickerE;
        }
        tickerE = [NSString stringWithFormat:@"%@%@", [tickerD substringToIndex:1], tickerD];
        if (![otherTickers containsObject:tickerE]) {
            return tickerE;
        }
    }
    
    return nil;
}




@end
