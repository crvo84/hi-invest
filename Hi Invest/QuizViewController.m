//
//  QuizViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizViewController.h"
#import "DefaultColors.h"
#import "QuizQuestion.h"
#import "Quiz.h"

@interface QuizViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mistakeCountImages;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *answerImageViews;
@property (strong, nonatomic) QuizQuestion *currentQuizQuestion;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger secondsLeft;
@property (nonatomic) NSUInteger mistakeCount;

@end

@implementation QuizViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Bar
    [self.navigationController.navigationBar setBarTintColor:[[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]]];
    
    // Answer Buttons
    for (UIButton *answerButton in self.answerButtons) {
        answerButton.layer.cornerRadius = 5;
        answerButton.layer.masksToBounds = YES;
        answerButton.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
    }
    
    // Mistake Count Images
    self.mistakeCount = 0;
    [self updateMistakeCountImages];
    
    [self resetAnswerImageViews];

    [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
}

- (void)resetAnswerImageViews
{
    for (UIImageView *answerImageView in self.answerImageViews) {
        answerImageView.alpha = 0.0;
    }
}

- (void)updateMistakeCountImages
{
    for (int i = 0; i < [self.mistakeCountImages count]; i++) {
        
        UIImageView *mistakeCountImageView = self.mistakeCountImages[i];
        mistakeCountImageView.image = [[UIImage imageNamed:@"incorrectB"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        if (i < self.quiz.mistakesAllowed) {
            mistakeCountImageView.alpha = 1.0;
            
        } else {
            mistakeCountImageView.alpha = 0.0;
        }
        
        if (i < self.mistakeCount) {
            [mistakeCountImageView setTintColor:[UIColor redColor]];
            
        } else {
            [mistakeCountImageView setTintColor:[UIColor lightGrayColor]];
            
        }
    }
}

- (void)setupUIForQuizQuestion:(QuizQuestion *)quizQuestion
{
    if (quizQuestion) {
        
        [self resetAnswerImageViews];
        
        self.currentQuizQuestion = quizQuestion;
        
        if (quizQuestion.questionType == QuizQuestionTypeImageQuestionImageAnswers || quizQuestion.questionType == QuizQuestionTypeImageQuestionTextAnswers) {
            
            self.questionLabel.alpha = 0.0;
            self.questionImageView.alpha = 1.0;
            self.questionImageView.image = [[UIImage imageNamed:quizQuestion.question] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
        } else {
            
            self.questionImageView.alpha = 0.0;
            self.questionLabel.alpha = 1.0;
            self.questionLabel.text = quizQuestion.question;
            
        }
        
        if ([quizQuestion.answers count] == [self.answerButtons count]) {
            for (int i = 0; i < [self.answerButtons count]; i++) {
                
                UIButton *answerButton = self.answerButtons[i];
                [answerButton setTitle:quizQuestion.answers[i] forState:UIControlStateNormal];
            }
        }

        self.secondsLeft = self.quiz.secondsPerQuestion;
        self.timeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.secondsLeft];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(timerAction)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)timerAction
{
    if (self.secondsLeft == 0) {
        
        [self.timer invalidate];
        
        self.mistakeCount++;
        [self updateMistakeCountImages];
        
        [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
        
    } else {

        self.timeLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)--self.secondsLeft];
    }
    
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    if (!self.currentQuizQuestion) return;
    
    [self.timer invalidate];
    
    UIImageView *selectedButtonImageView = self.answerImageViews[sender.tag];
    UIImage *selectedButtonImage;
    UIColor *selectedButtonImageColor;
    
    if (sender.tag == self.currentQuizQuestion.correctAnswerIndex) {
        
        // Correct Answer
        selectedButtonImage = [UIImage imageNamed:@"correctB"];
        selectedButtonImageColor = [UIColor greenColor];
        
    } else {
        
        // Wrong Answer
        selectedButtonImage = [UIImage imageNamed:@"incorrectB"];
        selectedButtonImageColor = [UIColor redColor];
        
        self.mistakeCount++;
        [self updateMistakeCountImages];

    }
    
    selectedButtonImageView.image = [selectedButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [selectedButtonImageView setTintColor:selectedButtonImageColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        selectedButtonImageView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
        
    }];
    
}

- (IBAction)cancelQuiz:(id)sender {
    
    [self.timer invalidate];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quiz canceled"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}




@end
