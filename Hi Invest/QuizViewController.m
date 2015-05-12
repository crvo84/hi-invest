//
//  QuizViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizViewController.h"
#import "QuizQuestion.h"

@interface QuizViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (strong, nonatomic) QuizQuestion *currentQuestion;

@end

@implementation QuizViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNewQuestion];
}

- (void)setupNewQuestion
{
    self.currentQuestion = [self.questions firstObject];
    
    if (self.currentQuestion) {
        self.questionLabel.text = self.currentQuestion.question;
        if ([self.currentQuestion.answers count] == [self.answerButtons count]) {
            for (int i = 0; i < [self.answerButtons count]; i++) {
                UIButton *answerButton = self.answerButtons[i];
                [answerButton setTitle:self.currentQuestion.answers[i] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    if (!self.currentQuestion) return;
    
    if (sender.tag == self.currentQuestion.correctAnswerIndex) {
        
        [self.questions removeObject:self.currentQuestion];
        self.currentQuestion = nil;
        
        [self setupNewQuestion];
        
    } else {

    }
}

- (IBAction)pauseQuiz:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quit Quiz?"
                                                                   message:@"Score from this quiz will be lost."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Quit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:quitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
