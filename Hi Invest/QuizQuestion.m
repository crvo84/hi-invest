//
//  QuizQuestion.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizQuestion.h"

@implementation QuizQuestion

#pragma mark - Getters

- (NSInteger)correctScore
{
    if (self.questionType == QuizQuestionTypeTermDefinition) {
        return 2;
    } else if (self.questionType == QuizQuestionTypeMarketCountry) {
        return 2;
    }
    
    return 0;
}

- (NSInteger)wrongScore
{
    if (self.questionType == QuizQuestionTypeTermDefinition) {
        return -1;
    } else if (self.questionType == QuizQuestionTypeMarketCountry) {
        return -1;
    }
    
    return 0;
}

@end
