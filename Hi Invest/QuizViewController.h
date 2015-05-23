//
//  QuizViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"

@interface QuizViewController : UIViewController

@property (strong, nonatomic) Quiz *quiz;
@property (nonatomic) QuizType quizType;
@property (nonatomic) BOOL quizAlreadyDone;
@property (nonatomic) BOOL succesfulQuiz;

@end
