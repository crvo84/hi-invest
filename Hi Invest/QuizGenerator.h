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

// Return a quiz with the given difficulty level, starting from 0
- (Quiz *)getQuizWithType:(QuizType)quizType andDifficultyLevel:(NSInteger)difficultyLevel;

// Return the title to show for the given quizType
- (NSString *)titleForQuizType:(QuizType)quizType;

// Return the maximum difficulty level available for the given quizType
- (NSInteger)maximumDifficultyLevelForQuizType:(QuizType)quizType;

@end
