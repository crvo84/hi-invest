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



@implementation QuizGenerator

#define numberOfAnswers 4 // Number of answers for each QuizQuestion. 1 correct, the rest are wrong

- (Quiz *)getQuizWithType:(QuizType)quizType andLevel:(NSUInteger)quizLevel
{
    NSUInteger numberOfQuizQuestions = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel];
    NSArray *quizQuestions = [self quizQuestionsForQuizType:quizType withNumberOfQuizQuestions:numberOfQuizQuestions];
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


- (NSMutableArray *)quizQuestionsForQuizType:(QuizType)quizType withNumberOfQuizQuestions:(NSUInteger)numberOfQuizQuestions
{
    if (quizType == QuizTypeFinancialRatioFormulas) {

        return [self quizQuestionsFromDictionary:FinancialRatiosImageFilenamesDictionary
                           withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeImageQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitions) {
        
        return [self quizQuestionsFromDictionary:FinancialRatiosDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialStatementDefinitions) {

        return [self quizQuestionsFromDictionary:FinancialStatementTermDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeStockMarketDefinitions) {
        
        return [self quizQuestionsFromDictionary:StockMarketTermDefinitionsDictionary
                       withNumberOfQuizQuestions:numberOfQuizQuestions
                            withQuizQuestionType:QuizQuestionTypeTextQuestionTextAnswers];
        
    } else if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        
        NSMutableArray *questions = [self quizQuestionsForQuizType:QuizTypeFinancialRatioDefinitions
                                         withNumberOfQuizQuestions:numberOfQuizQuestions / 2 + numberOfQuizQuestions % 2];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialRatioFormulas
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 2]];

        return [self randomSortArray:questions];

        
    } else if (quizType == QuizTypeAllDefinitions) {
        
        NSMutableArray *questions = [self quizQuestionsForQuizType:QuizTypeFinancialRatioDefinitions
                                         withNumberOfQuizQuestions:numberOfQuizQuestions / 4];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialRatioFormulas
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialStatementDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4 + numberOfQuizQuestions % 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeStockMarketDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        return [self randomSortArray:questions];
    }
    
    return nil;
}

- (NSMutableArray *)quizQuestionsFromDictionary:(NSDictionary *)dictionary withNumberOfQuizQuestions:(NSInteger)numberOfQuizQuestions withQuizQuestionType:(QuizQuestionType)quizQuestionType
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
        for (int i = 0;  i < numberOfAnswers - 1; i++) {
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

- (NSDictionary *)quizInfoWithType:(QuizType)quizType andLevel:(NSUInteger)quizLevel
{
    NSString *title = [self titleForQuizType:quizType];
    
    NSString *numberOfQuestionsStr = [NSString stringWithFormat:@"%ld", [self numberOfQuestionsForQuizType:quizType
                                                                                           forQuizLevel:quizLevel]];
    NSString *secondsPerQuestionStr = [NSString stringWithFormat:@"%ld", [self secondsPerQuestionForQuizType:quizType
                                                                                             forQuizLevel:quizLevel]];
    NSString *mistakesAllowedStr = [NSString stringWithFormat:@"%ld", [self mistakesAllowedForQuizType:quizType
                                                                                       forQuizLevel:quizLevel]];
    NSString *maxScoreStr = [NSString stringWithFormat:@"%ld", [self maximumScoreForQuizType:quizType
                                                                                forQuizLevel:quizLevel]];
    NSString *minScoreStr = [NSString stringWithFormat:@"%ld", [self minimumScoreForQuizType:quizType
                                                                                forQuizLevel:quizLevel]];
    return @{ QuizInfoTitleKey : title, QuizInfoNumberOfQuestionsKey : numberOfQuestionsStr, QuizInfoSecondsPerQuestionKey : secondsPerQuestionStr, QuizInfoMistakesAllowedKey : mistakesAllowedStr, QuizInfoMaxScoreKey : maxScoreStr, QuizInfoMinScoreKey : minScoreStr };
}

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


- (NSUInteger)numberOfQuestionsForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    return quizLevel * 5;
}


- (NSString *)titleForQuizType:(QuizType)quizType
{
    if (quizType == QuizTypeAllDefinitions) {
        return @"Financial Definitions";
    }
    
    if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) {
        return @"Financial Ratios";
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
        return @"Calculation Formulas";
    }
    
    if (quizType == QuizTypeFinancialRatioInterpretations) {
        return @"Ratio Interpretation";
    }
    
    if (quizType == QuizTypeFinancialRatioComparisons) {
        return @"Ratio Comparison";
    }
    
    return nil;
}


- (NSUInteger)secondsPerQuestionForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    if (quizType == QuizTypeFinancialRatioComparisons) {
        return 20;
    }
    
    if (quizType == QuizTypeFinancialRatioInterpretations) {
        return 20;
    }
    
    return 15;
}

- (NSUInteger)mistakesAllowedForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    return 3;
}

- (NSInteger)maximumScoreForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    return quizLevel * 100;
}


- (NSInteger)minimumScoreForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    return 0;
}













@end
