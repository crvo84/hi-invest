//
//  QuizGenerator.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizGenerator.h"
#import "QuizQuestion.h"
#import "RatiosKeys.h"
#import "GlossaryKeys.h"

#define QuizGeneratorMaximumQuizLevel 5
#define QuizGeneratorNumberOfAnswers 4 // Number of answers for each QuizQuestion. 1 correct, the rest are wrong
#define QuizGeneratorMaximumMistakesAllowed 3

@implementation QuizGenerator


// Return a dictionary containting information for a quiz with the given characteristics.
// QuizType is stored as a NSNumber
- (NSDictionary *)quizInfoWithType:(QuizType)quizType andLevel:(NSInteger)quizLevel
{
    if (![self isQuizAvailableForQuizLevel:quizLevel forQuizType:quizType]) {
        return nil;
    }
    
    NSString *title = [self titleForQuizType:quizType];
    
    NSString *numberOfQuestionsStr = [NSString stringWithFormat:@"%ld", (unsigned long)[self numberOfQuestionsForQuizType:quizType
                                                                                                             forQuizLevel:quizLevel]];
    NSString *secondsPerQuestionStr = [NSString stringWithFormat:@"%ld", (unsigned long)[self secondsPerQuestionForQuizType:quizType
                                                                                                               forQuizLevel:quizLevel]];
    NSString *mistakesAllowedStr = [NSString stringWithFormat:@"%ld", (unsigned long)[self mistakesAllowedForQuizType:quizType
                                                                                                         forQuizLevel:quizLevel]];
    NSString *maxScoreStr = [NSString stringWithFormat:@"%ld", (long)[self maximumScoreForQuizType:quizType
                                                                                      forQuizLevel:quizLevel]];
    NSString *minScoreStr = [NSString stringWithFormat:@"%ld", (long)[self minimumScoreForQuizType:quizType
                                                                                      forQuizLevel:quizLevel]];
    return @{ QuizInfoTitleKey : title, QuizInfoType : @(quizType), QuizInfoNumberOfQuestionsKey : numberOfQuestionsStr, QuizInfoSecondsPerQuestionKey : secondsPerQuestionStr, QuizInfoMistakesAllowedKey : mistakesAllowedStr, QuizInfoMaxScoreKey : maxScoreStr, QuizInfoMinScoreKey : minScoreStr };
}


// Return a quiz with the given characteristics
- (Quiz *)getQuizWithType:(QuizType)quizType andLevel:(NSInteger)quizLevel
{
    if (![self isQuizAvailableForQuizLevel:quizLevel forQuizType:quizType]) {
        return nil;
    }
    
    NSUInteger numberOfQuizQuestions = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel];
    NSArray *quizQuestions = [self quizQuestionsForQuizType:quizType withNumberOfQuizQuestions:numberOfQuizQuestions];
    
    // Maybe not enough definitions to initial number request
    numberOfQuizQuestions = [quizQuestions count];
    
    NSString *title = [self titleForQuizType:quizType];
    NSUInteger secondsPerQuestions = [self secondsPerQuestionForQuizType:quizType forQuizLevel:quizLevel];
    NSUInteger mistakesAllowed = [self mistakesAllowedForQuizType:quizType forQuizLevel:quizLevel];
    NSInteger maxScore = [self maximumScoreForQuizType:quizType forQuizLevel:quizLevel];
    NSInteger minScore = [self minimumScoreForQuizType:quizType forQuizLevel:quizLevel];
    
    return [[Quiz alloc] initWithTitle:title
                     withQuizQuestions:quizQuestions
                withSecondsPerQuestion:secondsPerQuestions
           withNumberOfMistakesAllowed:mistakesAllowed
                      withMaximumScore:maxScore
                      withMinimumScore:minScore];
}


// Return a mutable array with quiz questions with the given characteristics
- (NSMutableArray *)quizQuestionsForQuizType:(QuizType)quizType withNumberOfQuizQuestions:(NSUInteger)numberOfQuizQuestions
{
    NSMutableArray *quizQuestions = nil;
    
    if (quizType == QuizTypeFinancialRatioFormulas) {

        quizQuestions = [self definitionQuizQuestionsFromDictionary:FinancialRatiosImageFilenamesDictionary
                           withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeImageQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitions) {
        
        quizQuestions = [self definitionQuizQuestionsFromDictionary:FinancialRatiosDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialStatementDefinitions) {

        quizQuestions = [self definitionQuizQuestionsFromDictionary:FinancialStatementTermDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeStockMarketDefinitions) {
        
        quizQuestions = [self definitionQuizQuestionsFromDictionary:StockMarketTermDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        
        NSMutableArray *questions = [self quizQuestionsForQuizType:QuizTypeFinancialRatioDefinitions
                                         withNumberOfQuizQuestions:numberOfQuizQuestions / 2 + numberOfQuizQuestions % 2];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialRatioFormulas
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 2]];

        quizQuestions = [self randomSortArray:questions];

        
    } else if (quizType == QuizTypeAllDefinitions) {
        
        NSMutableArray *questions = [self quizQuestionsForQuizType:QuizTypeFinancialRatioDefinitions
                                         withNumberOfQuizQuestions:numberOfQuizQuestions / 4];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialRatioFormulas
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialStatementDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4 + numberOfQuizQuestions % 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeStockMarketDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        quizQuestions = [self randomSortArray:questions];
        
    } else if (quizType == QuizTypeFinancialRatioInterpretations) {
        
        quizQuestions = [self interpretationQuizQuestionsWithNumber:numberOfQuizQuestions];
        
    }
    
    return quizQuestions;
}


#pragma mark - Question generation methods

// return a mutable array containing quiz questions of the type term-definition
- (NSMutableArray *)definitionQuizQuestionsFromDictionary:(NSDictionary *)dictionary withNumberOfQuizQuestions:(NSInteger)numberOfQuizQuestions withQuizQuestionType:(QuizQuestionType)quizQuestionType
{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    if (numberOfQuizQuestions > [dictionary count]) {
        numberOfQuizQuestions = [dictionary count];
    }
    
    NSArray *allKeys = [dictionary allKeys];
    NSMutableArray *selectedKeys = [allKeys mutableCopy];
    while ([selectedKeys count] > numberOfQuizQuestions) {
        NSUInteger randomIndex = arc4random() % [selectedKeys count];
        [selectedKeys removeObjectAtIndex:randomIndex];
    }
    
    for (NSString *selectedKey in selectedKeys) {
        
        // Array of all terms
        NSMutableArray *keysLeft = [allKeys mutableCopy];
        // Remove correct term from array
        [keysLeft removeObject:selectedKey];
        
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        
        // Wrong answers
        for (int i = 0;  i < QuizGeneratorNumberOfAnswers - 1; i++) {
            NSUInteger randomIndex = arc4random() % [keysLeft count];
            NSString *wrongAnswer = keysLeft[randomIndex];
            [answers addObject:wrongAnswer];
            [keysLeft removeObject:wrongAnswer];
        }
        
        // Add the correct answer at a random index
        NSUInteger correctAnswerIndex = arc4random() % ([answers count] + 1);
        [answers insertObject:selectedKey atIndex:correctAnswerIndex];
        
        // Create QuizQuestion
        QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithType:quizQuestionType withQuestion:dictionary[selectedKey] withAnswers:answers withCorrectAnswerIndex:correctAnswerIndex];
        
        [questions addObject:quizQuestion];
    }
    
    return questions;
}

// Return a mutable array containing quiz questions of the type interpretation-ratio
- (NSMutableArray *)interpretationQuizQuestionsWithNumber:(NSInteger)numberOfQuizQuestions
{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:Locale];
    numberFormatter.maximumFractionDigits = 2;
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    for (int i = 0; i < numberOfQuizQuestions; i++) {

        NSArray *allKeys = [FinancialRatiosInterpretationsDictionary allKeys];
        
        NSString *ratioId = allKeys[arc4random() % [allKeys count]];
        
        NSNumber *maxValueNumber = FinancialRatioMaxAndMinValuesDictionary[ratioId][FinancialRatioMaxValueKey];
        NSNumber *minValueNumber = FinancialRatioMaxAndMinValuesDictionary[ratioId][FinancialRatioMinValueKey];
        
        NSNumber *ratioValueNumber = [self randomNumberBetweenMinimumNumber:minValueNumber andMaximumNumber:maxValueNumber];
        
        // QUESTION
        NSString *ratioValueStr = [numberFormatter stringFromNumber:ratioValueNumber];
        NSString *questionStr = [NSString stringWithFormat:FinancialRatiosInterpretationsDictionary[ratioId], ratioValueStr];
        // ------------
        
        // WRONG ANSWERS
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        for (int i = 0; i < QuizGeneratorNumberOfAnswers - 1; i++) {
            
            NSString *randomRatioId = allKeys[arc4random() % [allKeys count]];
            
            while (randomRatioId == ratioId) {
                randomRatioId = allKeys[arc4random() % [allKeys count]];
            }
            
            [answers addObject:randomRatioId];
        }
        // ------------
        
        if (questionStr && answers) {
            // Add the correct answer at a random index
            NSInteger randomIndex = arc4random() % ([answers count] + 1);
            [answers insertObject:ratioId atIndex:randomIndex];
            
            QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithType:QuizQuestionTypeTextQuestionTextAnswers
                                                               withQuestion:questionStr
                                                                withAnswers:answers
                                                     withCorrectAnswerIndex:randomIndex];
            
            [questions addObject:quizQuestion];
        }
    }
    
    return questions;
}


#pragma mark - Quiz characteristics

// Return the maximum level available for the given quizType
// Return 0 for not implemented quizTypes
- (NSInteger)maximumLevelForQuizType:(QuizType)quizType
{
    for (NSInteger i = 0; i <= QuizGeneratorMaximumQuizLevel; i++) {
        if (![self isQuizAvailableForQuizLevel:(i + 1) forQuizType:quizType]) {
            return i;
        }
    }
    
    return 0;
}

- (BOOL)isQuizAvailableForQuizLevel:(NSInteger)quizLevel forQuizType:(QuizType)quizType
{
    
    
    if (quizLevel > QuizGeneratorMaximumQuizLevel) {
        return NO;
    }
    
    NSUInteger num = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel];
    NSUInteger maxNum = 0;
    
    if (quizType == QuizTypeFinancialRatioFormulas) {
        
        maxNum = [FinancialRatiosImageFilenamesDictionary count];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitions) {
        
        maxNum = [FinancialRatiosDefinitionsDictionary count];
        
    } else if (quizType == QuizTypeFinancialStatementDefinitions) {
        
        maxNum = [FinancialStatementTermDefinitionsDictionary count];
        
    } else if (quizType == QuizTypeStockMarketDefinitions) {
        
        maxNum = [StockMarketTermDefinitionsDictionary count];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        
        maxNum = [FinancialRatiosImageFilenamesDictionary count] + [FinancialRatiosDefinitionsDictionary count];
        
    } else if (quizType == QuizTypeAllDefinitions) {
        
        NSUInteger ratioFormulasCount = [FinancialRatiosImageFilenamesDictionary count];
        NSUInteger ratioDefinitionsCount = [FinancialRatiosDefinitionsDictionary count];
        NSUInteger financialStatementDefinitionsCount = [FinancialStatementTermDefinitionsDictionary count];
        NSUInteger stockMarketTermDefinitionsCount = [StockMarketTermDefinitionsDictionary count];
        
        maxNum = ratioFormulasCount + ratioDefinitionsCount + financialStatementDefinitionsCount + stockMarketTermDefinitionsCount;
        
    } else {
        maxNum = num;
    }
    
    if (quizType == QuizTypeFinancialRatioComparisons) { // NEED TO BE IMPLEMENTED
        return NO;
    }
    
    return num <= maxNum;
}

- (NSUInteger)numberOfQuestionsForQuizType:(QuizType)quizType forQuizLevel:(NSInteger)quizLevel
{
    NSUInteger num;
    
    switch (quizLevel) {
        case 1:
            num = 5;
            break;
        case 2:
            num = 15;
            break;
        case 3:
            num = 30;
            break;
        case 4:
            num = 50;
            break;
        case 5:
            num = 100;
            break;
        default:
            num = 0;
            break;
    }
    
    return num;
}


- (NSString *)titleForQuizType:(QuizType)quizType
{
    if (quizType == QuizTypeAllDefinitions) {
        return @"All Definitions";
    }
    
    if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        return @"Ratio Def. & Formulas";
    }
    
    if (quizType == QuizTypeFinancialRatioDefinitions) {
        return @"Ratio Definitions";
    }
    
    if (quizType == QuizTypeFinancialStatementDefinitions) {
        return @"Financial Statement";
    }
    
    if (quizType == QuizTypeStockMarketDefinitions) {
        return @"Stock Market";
    }
    
    if (quizType == QuizTypeFinancialRatioFormulas) {
        return @"Ratio Formulas";
    }
    
    if (quizType == QuizTypeFinancialRatioInterpretations) {
        return @"Ratio Interpretation";
    }
    
    if (quizType == QuizTypeFinancialRatioComparisons) {
        return @"Ratio Comparison";
    }
    
    return nil;
}


- (NSUInteger)secondsPerQuestionForQuizType:(QuizType)quizType forQuizLevel:(NSInteger)quizLevel
{
    if (quizLevel <= 2) {
        return 20;
    } else if (quizLevel <= 4) {
        return 15;
    } else if (quizLevel <= 6) {
        return 10;
    } else {
        return 5;
    }
}

- (NSUInteger)mistakesAllowedForQuizType:(QuizType)quizType forQuizLevel:(NSInteger)quizLevel
{
    NSUInteger mistakes = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel] / 30;
    
    return MIN(mistakes, QuizGeneratorMaximumMistakesAllowed);
}

- (NSInteger)maximumScoreForQuizType:(QuizType)quizType forQuizLevel:(NSInteger)quizLevel
{
    NSUInteger numberOfQuestions = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel];
    NSInteger pointsPerQuestion = 0;
    
    if (quizType == QuizTypeAllDefinitions) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialRatioDefinitions) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialStatementDefinitions) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeStockMarketDefinitions) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialRatioFormulas) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialRatioInterpretations) {
        pointsPerQuestion = 1;
    }
    
    if (quizType == QuizTypeFinancialRatioComparisons) {
        pointsPerQuestion = 1;
    }
    
    return numberOfQuestions * pointsPerQuestion;
}


- (NSInteger)minimumScoreForQuizType:(QuizType)quizType forQuizLevel:(NSInteger)quizLevel
{
    return 0;
}

#pragma mark - Helper methods

// Return a mutable array from the elements from the given array randomly sorted.
- (NSMutableArray *)randomSortArray:(NSArray *)array
{
    NSMutableArray *mutableArray;
    if ([array isKindOfClass:[NSMutableArray class]]) {
        mutableArray = (NSMutableArray *)array;
    } else {
        array = [array mutableCopy];
    }
    
    // Sort array in a random order
    NSInteger count = [array count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        
        // Select a random element between i and end of array to swap with.
        NSInteger elementsLeft = count - i;
        NSInteger randomIndex = (arc4random() % elementsLeft) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
    
    return mutableArray;
}

// Return a random NSNumber over the interval [minNum, maxNum]
- (NSNumber *)randomNumberBetweenMinimumNumber:(NSNumber *)minNumber andMaximumNumber:(NSNumber *)maxNumber
{
    double randomValue = drand48(); // Random value [0.0, 1.0]
    
    return @(randomValue * ([maxNumber doubleValue] - [minNumber doubleValue]) + [minNumber doubleValue]);
}









@end
