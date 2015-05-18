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



- (Quiz *)getQuizWithType:(QuizType)quizType andLevel:(NSUInteger)quizLevel;

@end
