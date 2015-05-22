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
#define QuizInfoType @"Type"
#define QuizInfoNumberOfQuestionsKey @"Number of questions"
#define QuizInfoSecondsPerQuestionKey @"Seconds per question"
#define QuizInfoMistakesAllowedKey @"Mistakes allowed"
#define QuizInfoMaxScoreKey @"Max score"
#define QuizInfoMinScoreKey @"Min score"

#define QuizGeneratorMaximumQuizLevel 5
#define QuizGeneratorNumberOfAnswers 4 // Including correct answer

// Return a dictionary containting information for a quiz with the given characteristics.
// QuizType is stored as a NSNumber
- (NSDictionary *)quizInfoWithType:(QuizType)quizType andLevel:(NSInteger)quizLevel;

// Return a quiz with the given characteristics
- (Quiz *)getQuizWithType:(QuizType)quizType andLevel:(NSInteger)quizLevel;

// Return the title to show for the given quizType
- (NSString *)titleForQuizType:(QuizType)quizType;

// Return the maximum level available for the given quizType
- (NSInteger)maximumLevelForQuizType:(QuizType)quizType;

@end
