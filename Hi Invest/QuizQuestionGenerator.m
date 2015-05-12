//
//  QuizQuestionGenerator.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizQuestionGenerator.h"
#import "QuizQuestion.h"
#import "RatiosKeys.h"

@interface QuizQuestionGenerator ()

@end

@implementation QuizQuestionGenerator

+ (NSMutableArray *)generateTermDefinitionQuestions
{
    return [self generateQuestionsOfType:QuizQuestionTypeTermDefinition];
}

+ (NSMutableArray *)generateQuestionsOfType:(QuizQuestionType)questionType
{
    NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    NSDictionary *termsDictionary;
    if (questionType == QuizQuestionTypeTermDefinition) {
        termsDictionary = FinancialRatiosDefinitionsDictionary;
    } else {
        return nil;
    }

    for (NSString *term in termsDictionary) {
        
        // Array of all terms
        NSMutableArray *termsLeft = [[termsDictionary allKeys] mutableCopy];
        // Remove correct term from array
        [termsLeft removeObject:term];
        
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        
        // 3 wrong definitions
        for (int i = 0; i < 3; i++) {
            NSUInteger randomIndex = arc4random() % [termsLeft count];
            NSString *wrongTerm = termsLeft[randomIndex];
            [answers addObject:wrongTerm];
            [termsLeft removeObject:wrongTerm];
        }
        
        // Add the correct definition at a random index
        NSUInteger correctDefinitionIndex = arc4random() % ([answers count] + 1);
        [answers insertObject:term atIndex:correctDefinitionIndex];
        
        QuizQuestion *question = [[QuizQuestion alloc] init];
        question.question = [NSString stringWithFormat:@"%@", termsDictionary[term]];
        question.questionType = questionType;
        question.answers = answers;
        question.correctAnswerIndex = correctDefinitionIndex;
        
        [questions addObject:question];
    }
    
    return questions;
}






















@end
