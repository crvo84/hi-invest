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
    QuizQuestionTypeTextQuestionTextAnswers,
    QuizQuestionTypeImageQuestionTextAnswers,
    QuizQuestionTypeTextQuestionImageAnswers,
    QuizQuestionTypeImageQuestionImageAnswers
} QuizQuestionType;

@property (nonatomic, readonly) QuizQuestionType questionType;
@property (strong, nonatomic, readonly) NSString *question;
@property (strong, nonatomic, readonly) NSArray *answers;
@property (nonatomic, readonly) NSInteger correctAnswerIndex;

// Designated Initializer.
// question parameter must contain a NSString with the question or with the image filename
// answers array parameter must contain NSStrings with the answers or with the image filenames
- (instancetype)initWithType:(QuizQuestionType)questionType withQuestion:(NSString *)question withAnswers:(NSArray *)answers withCorrectAnswerIndex:(NSInteger)correctAnswerIndex;




@end
