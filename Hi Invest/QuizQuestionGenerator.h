//
//  QuizQuestionGenerator.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QuizQuestion;

@interface QuizQuestionGenerator : NSObject

+ (NSMutableArray *)generateTermDefinitionQuestions;

@end