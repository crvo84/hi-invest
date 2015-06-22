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

#define QuizGeneratorNumberOfAnswers 4 // Answers for each QuizQuestion (including 1 correct)
#define QuizGeneratorMaxDifficultyLevel 6

/*
    DIFFICULTY LEVES. Are the same for all QuizTypes. New quiz types can be added.
 
    Difficulty Level 0: 05 questions | 2 mistakes allowed (40%) | 20 seconds
 
    Difficulty Level 1: 10 questions | 2 mistakes allowed (20%) | 20 seconds
 
    Difficulty Level 2: min(15, count) questions | 3 mistakes allowed (20%) | 15 seconds
 
    Difficulty Level 3: min(20, count) questions | 2 mistakes allowed (10%) | 15 seconds
 
    Difficulty Level 4: min(30, count) questions | 3 mistakes allowed (10%) | 10 seconds
 
    Difficulty Level 5: min(40, count) questions | 2 mistakes allowed (05%) | 10 seconds
 
    Difficulty Level 6: min(50, count) questions | 2 mistakes allowed (04%) | 5 seconds
 
 */

@implementation QuizGenerator

// Return a quiz with the given difficulty level, starting from 0
- (Quiz *)getQuizWithType:(QuizType)quizType andDifficultyLevel:(NSInteger)difficultyLevel;
{
    NSUInteger numberOfQuizQuestions = [self numberOfQuestionsForQuizType:quizType forDifficultyLevel:difficultyLevel];
    
    NSArray *quizQuestions = [self quizQuestionsForQuizType:quizType withNumberOfQuizQuestions:numberOfQuizQuestions];
    
    // Maybe not enough definitions to initial number of questions request
    numberOfQuizQuestions = [quizQuestions count];
    
    NSString *title = [self titleForQuizType:quizType];
    NSUInteger secondsPerQuestions = [self secondsPerQuestionForQuizType:quizType forDifficultyLevel:difficultyLevel];
    NSUInteger mistakesAllowed = [self mistakesAllowedForQuizType:quizType forDifficultyLevel:difficultyLevel];
    NSInteger maxScore = [self maximumScoreForQuizType:quizType forDifficultyLevel:difficultyLevel];
    NSInteger minScore = [self minimumScoreForQuizType:quizType forDifficultyLevel:difficultyLevel];
    
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
                                            withNumberOfQuizQuestions:numberOfQuizQuestions - [questions count]]];

        quizQuestions = [self randomSortArray:questions];

        
    } else if (quizType == QuizTypeAllDefinitions) {
        
        NSMutableArray *questions = [self quizQuestionsForQuizType:QuizTypeFinancialRatioDefinitions
                                         withNumberOfQuizQuestions:numberOfQuizQuestions / 4];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialRatioFormulas
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeStockMarketDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions / 4]];
        
        [questions addObjectsFromArray:[self quizQuestionsForQuizType:QuizTypeFinancialStatementDefinitions
                                            withNumberOfQuizQuestions:numberOfQuizQuestions - [questions count]]];
        
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
    numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    numberFormatter.maximumFractionDigits = 2;
    
    // All available ratio ids that haven't been selected for questions
    NSMutableArray *ratioIdentifiersLeft = [[FinancialRatiosInterpretationsDictionary allKeys] mutableCopy];
    
    if (numberOfQuizQuestions > [FinancialRatiosInterpretationsDictionary count]) {
        numberOfQuizQuestions = [FinancialRatiosInterpretationsDictionary count];
    }
    
    for (int i = 0; i < numberOfQuizQuestions; i++) {
        
        NSInteger ratioIdentifiersLeftCount = [ratioIdentifiersLeft count];
        // If there are no more ratio ids left to choose from, then break the loop.
        // (Even if the requested number of questions haven't been met yet)
        if (ratioIdentifiersLeftCount <= 0) {
            break;
        }

        // Pick a random ratioId from ratioIdentifiersLeft, then remove it from the array. (not available for questions now)
        NSString *correctRatioId = ratioIdentifiersLeft[arc4random() % ratioIdentifiersLeftCount];
        [ratioIdentifiersLeft removeObject:correctRatioId];
        
        NSNumber *maxValueNumber = FinancialRatioMaxAndMinValuesDictionary[correctRatioId][FinancialRatioMaxValueKey];
        NSNumber *minValueNumber = FinancialRatioMaxAndMinValuesDictionary[correctRatioId][FinancialRatioMinValueKey];
        
        NSNumber *ratioValueNumber = [self randomNumberBetweenMinimumNumber:minValueNumber andMaximumNumber:maxValueNumber];
        
        // QUESTION
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.maximumFractionDigits = 2;
        NSString *ratioValueStr = [numberFormatter stringFromNumber:ratioValueNumber];
        NSString *questionStr = [NSString stringWithFormat:FinancialRatiosInterpretationsDictionary[correctRatioId], ratioValueStr];
        // ------------
        
        // WRONG ANSWERS
        // Choose different ratioId for wrong answers.
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        
        // Array of all available ratio ids except the correct answer ratio id
        NSMutableArray *wrongAnswersAvailable = [[FinancialRatiosInterpretationsDictionary allKeys] mutableCopy];
        [wrongAnswersAvailable removeObject:correctRatioId];
        
        for (int i = 0; i < QuizGeneratorNumberOfAnswers - 1; i++) {
            NSInteger wrongAnswersAvailableCount = [wrongAnswersAvailable count];
            
            if (wrongAnswersAvailableCount <= 0) break; // If not enough answers
            
            // Pick random wrong answer
            NSString *randomWrongAnswer = wrongAnswersAvailable[arc4random() % wrongAnswersAvailableCount];
            // Remove from wrong available answers
            [wrongAnswersAvailable removeObject:randomWrongAnswer];
            
            // Add answer ratio value to wrong answer in corresponding number style
            if ([FinancialSortingValuesPercentValuesArray containsObject:randomWrongAnswer]) {
                numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
                numberFormatter.maximumFractionDigits = 0;
            } else {
                numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                numberFormatter.maximumFractionDigits = 2;
            }
            randomWrongAnswer = [NSString stringWithFormat:@"%@  |  %@", randomWrongAnswer, [numberFormatter stringFromNumber:ratioValueNumber]];
            
            [answers addObject:randomWrongAnswer];
        }
        // ------------
        
        if (questionStr && answers) {
            // Add the correct answer at a random index
            if ([FinancialSortingValuesPercentValuesArray containsObject:correctRatioId]) {
                numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
                numberFormatter.maximumFractionDigits = 0;
            } else {
                numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                numberFormatter.maximumFractionDigits = 2;
            }
            correctRatioId = [NSString stringWithFormat:@"%@  |  %@", correctRatioId, [numberFormatter stringFromNumber:ratioValueNumber]];
            NSInteger randomCorrectIndex = arc4random() % ([answers count] + 1);
            [answers insertObject:correctRatioId atIndex:randomCorrectIndex];
            
            QuizQuestion *quizQuestion = [[QuizQuestion alloc] initWithType:QuizQuestionTypeTextQuestionTextAnswers
                                                               withQuestion:questionStr
                                                                withAnswers:answers
                                                     withCorrectAnswerIndex:randomCorrectIndex];
            
            [questions addObject:quizQuestion];
        }
    }
    
    return questions;
}


#pragma mark - Quiz characteristics

// Return the maximum difficulty level available for the given quizType
- (NSInteger)maximumDifficultyLevelForQuizType:(QuizType)quizType;
{
    return QuizGeneratorMaxDifficultyLevel;
}


- (NSUInteger)numberOfQuestionsForQuizType:(QuizType)quizType forDifficultyLevel:(NSInteger)difficultyLevel
{
    NSUInteger num = 0;

    switch (difficultyLevel) {
        case 0:
            num = 5;
            break;
        case 1:
            num = 10;
            break;
        case 2:
            num = 15;
            break;
        case 3:
            num = 20;
            break;
        case 4:
            num = 30;
            break;
        case 5:
            num = 40;
            break;
        case 6:
            num = 50;
            break;
        default:
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
    
    return nil;
}


- (NSUInteger)secondsPerQuestionForQuizType:(QuizType)quizType forDifficultyLevel:(NSInteger)difficultyLevel
{
    NSUInteger seconds = 0;
    switch (difficultyLevel) {
        case 0:
            seconds = 20;
            break;
        case 1:
            seconds = 20;
            break;
        case 2:
            seconds = 15;
            break;
        case 3:
            seconds = 15;
            break;
        case 4:
            seconds = 10;
            break;
        case 5:
            seconds = 10;
            break;
        case 6:
            seconds = 5;
            break;
        default:
            break;
    }
    
    return seconds;
}

- (NSUInteger)mistakesAllowedForQuizType:(QuizType)quizType forDifficultyLevel:(NSInteger)difficultyLevel
{
    NSUInteger mistakesAllowed = 0;
    switch (difficultyLevel) {
        case 0:
            mistakesAllowed = 2;
            break;
        case 1:
            mistakesAllowed = 2;
            break;
        case 2:
            mistakesAllowed = 3;
            break;
        case 3:
            mistakesAllowed = 2;
            break;
        case 4:
            mistakesAllowed = 3;
            break;
        case 5:
            mistakesAllowed = 2;
            break;
        case 6:
            mistakesAllowed = 2;
            break;
        default:
            break;
    }
    
    return mistakesAllowed;
}

- (NSInteger)maximumScoreForQuizType:(QuizType)quizType forDifficultyLevel:(NSInteger)difficultyLevel
{
    return 1;
}


- (NSInteger)minimumScoreForQuizType:(QuizType)quizType forDifficultyLevel:(NSInteger)difficultyLevel
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

- (BOOL)isValidQuizType:(QuizType)quizType
{
    BOOL isValidType = NO;

    if (quizType == QuizTypeFinancialRatioDefinitions) isValidType = YES;
    if (quizType == QuizTypeFinancialRatioFormulas) isValidType = YES;
    if (quizType == QuizTypeFinancialRatioDefinitionsAndFormulas) isValidType = YES;
    if (quizType == QuizTypeFinancialStatementDefinitions) isValidType = YES;
    if (quizType == QuizTypeStockMarketDefinitions) isValidType = YES;
    if (quizType == QuizTypeAllDefinitions) isValidType = YES;
    if (quizType == QuizTypeFinancialRatioInterpretations) isValidType = YES;
    
    return isValidType;
}







@end
