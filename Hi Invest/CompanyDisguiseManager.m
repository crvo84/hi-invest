//
//  CompanyDisguiseManager.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompanyDisguiseManager.h"

@interface CompanyDisguiseManager ()

@property (strong, nonatomic) NSMutableDictionary *tickersChanged; // @{ real ticker : fictional ticker NSString }
@property (strong, nonatomic) NSMutableDictionary *namesChanged; // @{ real ticker : fictional name NSString }
@property (strong, nonatomic) NSMutableDictionary *priceMultipliers; // @{ real ticker : @(price multiplier) double }

@property (nonatomic) BOOL changeRealNamesAndTickers;

@end

@implementation CompanyDisguiseManager

// Designated initializer
- (instancetype)initWithCompaniesRealTickers:(NSArray *)realTickers andFictionalNames:(NSArray *)fictionalNames
{
    self = [super init];
    
    if (self) {
        // Get a mutable dictionary with fictional company info @{ TICKER : NAME }
        NSDictionary *fictionalCompanyInfo = [self randomFictionalCompanyInfoFromNames:fictionalNames
                                                                         forNumberOfCompanies:[realTickers count]];
        
        NSMutableArray *fictionalTickersLeft = [[fictionalCompanyInfo allKeys] mutableCopy];
        
        for (NSString *realTicker in realTickers) {
            
            if ([fictionalTickersLeft count] > 0) {
                
                NSString *fictionalTicker = [fictionalTickersLeft firstObject];
                NSString *fictionalName = fictionalCompanyInfo[fictionalTicker];
                [fictionalTickersLeft removeObject:fictionalTicker];
                // Random double between 0.5 and 1.5 to multiply prices
                double priceMultiplier = (arc4random() % 101) / 100 + 0.5;
                
                self.tickersChanged[realTicker] = fictionalTicker;
                self.namesChanged[realTicker] = fictionalName;
                self.priceMultipliers[realTicker] = @(priceMultiplier);
                
            } else {
                NSLog(@"CompanyDisguise error. Not enough valid fictional names");
                return nil;
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
- (double)priceMultiplierFromTicker:(NSString *)ticker
{
    NSNumber *priceMultiplierNumber = self.priceMultipliers[ticker];
    
    if (!priceMultiplierNumber) {
        return NSNotFound;
    }
    
    return [priceMultiplierNumber doubleValue];
}


#pragma mark - Random Info Generator

#define FictionalNameCompanyTypes @[@"INC", @"CO", @"CORP"]
// Return a dictionary mapping fictional ticker with the corresponding given fictional name.
// The result count is equal to the given number and generated randomly selecting from the given names.
// Return nil if no enough names to create asked tickers.
- (NSMutableDictionary *)randomFictionalCompanyInfoFromNames:(NSArray *)names forNumberOfCompanies:(NSUInteger)number
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *namesLeft = [names mutableCopy];
    NSMutableSet *otherTickers = [[NSMutableSet alloc] init];
    
    while ([result count] < number) {
        NSInteger namesLeftCount = [namesLeft count];
        
        if (namesLeftCount <= 0) {
            return nil;
        }
        
        NSInteger randomIndex = arc4random() % namesLeftCount;
        NSString *fictionalName = namesLeft[randomIndex];
        [namesLeft removeObject:fictionalName];
        
        NSString *fictionalTicker = [self fictionalTickerForName:fictionalName notPresentInSet:otherTickers];
        
        if (fictionalTicker) {
            
            NSInteger companyTypeIndex = arc4random() % [FictionalNameCompanyTypes count];
            NSString *companyType = FictionalNameCompanyTypes[companyTypeIndex];
            fictionalName = [NSString stringWithFormat:@"%@ %@", fictionalName, companyType];
            
            result[fictionalTicker] = fictionalName;
            [otherTickers addObject:fictionalTicker];
        }
    }

    return result;
}

// Return a upper case 3 or 4 letter ticker generated from the given name, not included in the given set
// Return nil if ticker could not be generated.
- (NSString *)fictionalTickerForName:(NSString *)name notPresentInSet:(NSSet *)otherTickers
{
    // Remove all blank spaces and convert to all upercase
    NSString *lettersStr = [[name stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
    
    if (lettersStr.length >= 3) {
        
        // A) First three characters
        NSString *tickerA = [lettersStr substringToIndex:3];
        if (![otherTickers containsObject:tickerA]) {
            return tickerA;
        }
        
        // B) First two character + last character
        NSString *tickerB = [NSString stringWithFormat:@"%@%@", [lettersStr substringToIndex:2], [lettersStr substringFromIndex:lettersStr.length - 1]];
        if (![otherTickers containsObject:tickerB]) {
            return tickerB;
        }
        
        // C) First character + last two characters
        NSString *tickerC = [NSString stringWithFormat:@"%@%@", [lettersStr substringToIndex:1], [lettersStr substringFromIndex:lettersStr.length - 2]];
        if (![otherTickers containsObject:tickerC]) {
            return tickerC;
        }
        
        // D) A, B or C with double initial letter
        NSString *tickerD = [NSString stringWithFormat:@"%@%@", [tickerA substringToIndex:1], tickerA];
        if (![otherTickers containsObject:tickerD]) {
            return tickerD;
        }
        tickerD = [NSString stringWithFormat:@"%@%@", [tickerB substringToIndex:1], tickerB];
        if (![otherTickers containsObject:tickerD]) {
            return tickerD;
        }
        tickerD = [NSString stringWithFormat:@"%@%@", [tickerC substringToIndex:1], tickerC];
        if (![otherTickers containsObject:tickerD]) {
            return tickerD;
        }
    }
    
    return nil;
}





@end
