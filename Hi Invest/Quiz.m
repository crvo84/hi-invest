//
//  Quiz.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Quiz.h"

@interface Quiz ()

@property (copy, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSArray *quizQuestions;
@property (nonatomic, readwrite) NSUInteger secondsPerQuestion;
@property (nonatomic, readwrite) NSUInteger mistakesAllowed;
@property (nonatomic, readwrite) NSInteger maxScore;
@property (nonatomic, readwrite) NSInteger minScore;
@property (nonatomic, readwrite) QuizType quizType;
@property (nonatomic) NSInteger nextQuizQuestionIndex; // Zero base index

@end

@implementation Quiz

// Designated Initializer
- (instancetype)initWithTitle:(NSString *)title
            withQuizQuestions:(NSArray *)quizQuestions
       withSecondsPerQuestion:(NSUInteger)secondsPerQuestion
  withNumberOfMistakesAllowed:(NSUInteger)mistakesAllowed
             withMaximumScore:(NSInteger)maxScore
             withMinimumScore:(NSInteger)minScore
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.quizQuestions = quizQuestions;
        self.secondsPerQuestion = secondsPerQuestion;
        self.mistakesAllowed = mistakesAllowed;
        self.maxScore = maxScore;
        self.minScore = minScore;
        self.nextQuizQuestionIndex = 0;
    }
    
    return self;
}

// Return the next QuizQuestion. nil if no more QuizQuestion objects available
- (QuizQuestion *)getNewQuizQuestion
{
    QuizQuestion *quizQuestion = nil;
    
    if (self.nextQuizQuestionIndex < [self.quizQuestions count]) {
        
        quizQuestion = self.quizQuestions[self.nextQuizQuestionIndex];
        self.nextQuizQuestionIndex++;
        
    }
    
    return quizQuestion;
}



@end
