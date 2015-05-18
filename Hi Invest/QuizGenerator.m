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
    
    NSArray *quizQuestions = [self quizQuestionsForQuizType:quizType forQuizLevel:quizLevel];
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


- (NSArray *)quizQuestionsForQuizType:(QuizType)quizType forQuizLevel:(NSUInteger)quizLevel
{
    NSDictionary *dictionary;
    QuizQuestionType quizQuestionType;
    
    if (quizType == QuizTypeFinancialRatioFormulas) {
        
        dictionary = FinancialRatiosImageFilenamesDictionary;
        quizQuestionType = QuizQuestionTypeImageQuestionTextAnswers;
        
    } else if (quizType == QuizTypeFinancialRatioDefinitions) {
        
        dictionary = FinancialRatiosDefinitionsDictionary;
        quizQuestionType = QuizQuestionTypeTextQuestionTextAnswers;
        
    } else if (quizType == QuizTypeFinancialStatementDefinitions) {
        
        dictionary = FinancialStatementTermDefinitionsDictionary;
        quizQuestionType = QuizQuestionTypeTextQuestionTextAnswers;
        
    } else if (quizType == QuizTypeStockMarketDefinitions) {
        
        dictionary = StockMarketTermDefinitionsDictionary;
        quizQuestionType = QuizQuestionTypeTextQuestionTextAnswers;
        
    } else {
        return nil;
    }
    
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    NSUInteger numberOfQuestions = [self numberOfQuestionsForQuizType:quizType forQuizLevel:quizLevel];
    if (numberOfQuestions > [dictionary count]) {
        numberOfQuestions = [dictionary count];
    }
    

    NSArray *allKeys = [dictionary allKeys];
    
    NSMutableArray *selectedKeys = [allKeys mutableCopy];
    while ([selectedKeys count] > numberOfQuestions) {
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
        return 15;
    }
    
    if (quizType == QuizTypeFinancialRatioInterpretations) {
        return 15;
    }
    
    return 10;
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
