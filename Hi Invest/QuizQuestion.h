//
//  QuizQuestion.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizQuestion : NSObject

/* Types of questions:
 
 Real Examples. (Questions with real data)
 Practice questions. (A lot of questions to become expert)
 Calculate financial ratios.
 Match financial term with definition.
 
 */

typedef enum : NSInteger {
    QuizQuestionTypeTermDefinition,
    QuizQuestionTypeMarketCountry
} QuizQuestionType;

@property (copy, nonatomic) NSString *question;
@property (nonatomic) QuizQuestionType questionType;
@property (copy, nonatomic) NSArray *answers;
@property (nonatomic) NSInteger correctAnswerIndex;
@property (nonatomic, readonly) NSInteger correctScore;
@property (nonatomic, readonly) NSInteger wrongScore;

@end
