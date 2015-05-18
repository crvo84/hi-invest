//
//  QuizQuestion.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizQuestion.h"

@interface QuizQuestion ()

@property (nonatomic, readwrite) QuizQuestionType questionType;
@property (strong, nonatomic, readwrite) NSString *question;
@property (strong, nonatomic, readwrite) NSArray *answers; // of NSString
@property (nonatomic, readwrite) NSInteger correctAnswerIndex;
@end

@implementation QuizQuestion

// Designated Initializer.
// question parameter must contain a NSString with the question or with the image filename
// answers array parameter must contain NSStrings with the answers or with the image filenames
- (instancetype)initWithType:(QuizQuestionType)questionType withQuestion:(NSString *)question withAnswers:(NSArray *)answers withCorrectAnswerIndex:(NSInteger)correctAnswerIndex;
{
    self = [super init];
    
    if (self) {
        self.questionType = questionType;
        self.question = question;
        self.answers = answers;
        self.correctAnswerIndex = correctAnswerIndex;
    }
    
    return self;
}



@end
