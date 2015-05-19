//
//  QuizGenerator.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"

@interface QuizGenerator : NSObject

#define QuizInfoTitleKey @"Title"
#define QuizInfoNumberOfQuestionsKey @"Number of questions"
#define QuizInfoSecondsPerQuestionKey @"Seconds per question"
#define QuizInfoMistakesAllowedKey @"Mistakes allowed"
#define QuizInfoMaxScoreKey @"Max score"
#define QuizInfoMinScoreKey @"Min score"

- (Quiz *)getQuizWithType:(QuizType)quizType andLevel:(NSUInteger)quizLevel;

- (NSDictionary *)quizInfoWithType:(QuizType)quizType andLevel:(NSUInteger)quizLevel;

@end
