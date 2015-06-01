//
//  Quiz.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuizQuestion;

@interface Quiz : NSObject

typedef enum : NSInteger {
    QuizTypeFinancialRatioDefinitions = 0,
    QuizTypeFinancialRatioFormulas,
    QuizTypeFinancialRatioDefinitionsAndFormulas,
    QuizTypeFinancialStatementDefinitions,
    QuizTypeStockMarketDefinitions,
    QuizTypeAllDefinitions,
    QuizTypeFinancialRatioInterpretations,
    
    QuizTypeCount // This is the number of QuizTypes in the enum 
} QuizType;

@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSArray *quizQuestions;
@property (nonatomic, readonly) NSUInteger secondsPerQuestion;
@property (nonatomic, readonly) NSUInteger mistakesAllowed;
@property (nonatomic, readonly) NSInteger maxScore;
@property (nonatomic, readonly) NSInteger minScore;
@property (nonatomic, readonly) NSInteger nextQuizQuestionIndex; // Zero base index

// Designated Initializer
- (instancetype)initWithTitle:(NSString *)title
            withQuizQuestions:(NSArray *)quizQuestions
       withSecondsPerQuestion:(NSUInteger)secondsPerQuestion
  withNumberOfMistakesAllowed:(NSUInteger)mistakesAllowed
             withMaximumScore:(NSInteger)maxScore
             withMinimumScore:(NSInteger)minScore;

// Return the next QuizQuestion. nil if no more QuizQuestion objects available
- (QuizQuestion *)getNewQuizQuestion;

@end
