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

@interface QuizViewController ()

@property (strong, nonatomic) QuizQuestion *currentQuizQuestion;
// Initial Subview Outlets
@property (weak, nonatomic) IBOutlet UIView *initialSubview;
@property (weak, nonatomic) IBOutlet UILabel *initialInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialCountdownLabel;
// Final Subview Outlets
@property (weak, nonatomic) IBOutlet UIView *finalSubview;
@property (weak, nonatomic) IBOutlet UIButton *finalSubviewButton;
// Quiz Outlets
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mistakeCountImages;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSUInteger secondsLeft;
@property (nonatomic) NSUInteger mistakeCount;

@end

@implementation QuizViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NAV BAR SETUP
    [self.navigationController.navigationBar setBarTintColor:[[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]]];
    
    // INITIAL SUBVIEW SETUP
    self.initialSubview.hidden = NO;
    self.initialSubview.alpha = 1.0;
    self.initialSubview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.90];
    self.initialInfoLabel.text = [NSString stringWithFormat:@"%lu questions", (unsigned long)[self.quiz.quizQuestions count]];
    self.initialCountdownLabel.text = @"";

    // QUIZ SETUP
    // Mistake count
    self.mistakeCount = 0;
    [self updateMistakeCountImages];
    // Answer Buttons
    for (UIButton *answerButton in self.answerButtons) {
        answerButton.layer.cornerRadius = 3;
        answerButton.layer.masksToBounds = YES;
        answerButton.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
        answerButton.titleLabel.minimumScaleFactor = 0.7;
        answerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        answerButton.alpha = 0.0;
    }
    // Question views
    self.questionImageView.alpha = 0.0;
    self.questionLabel.alpha = 0.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                  target:self
                                                selector:@selector(countdownTimerAction)
                                                userInfo:nil
                                                 repeats:YES];
    
}

- (void)countdownTimerAction
{
    if ([self.initialCountdownLabel.text isEqualToString:@""]) {
        self.initialCountdownLabel.text = @"3";
        
    } else {
        NSInteger currentTime = [self.initialCountdownLabel.text intValue];
        
        if (currentTime > 1) {
            self.initialCountdownLabel.text = [NSString stringWithFormat:@"%ld", (long)--currentTime];
            
        } else {
            [self.timer invalidate];
            
            self.initialCountdownLabel.text = @"Go!";
            
            [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
                self.initialSubview.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.initialSubview.hidden = YES;
                [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
            }];
        }
    }
}


- (void)updateMistakeCountImages
{
    // Right-most image has the lowest tag
    for (NSInteger i = 0 ; i < [self.mistakeCountImages count] ; i++) {
        
        UIImageView *mistakeCountImageView = self.mistakeCountImages[i];
        
        mistakeCountImageView.image = [[UIImage imageNamed:@"ninjaEmoticon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        mistakeCountImageView.tintColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
        
        if (mistakeCountImageView.tag < self.mistakeCount) {
            mistakeCountImageView.alpha = 0.0;
            
        } else {
            mistakeCountImageView.alpha = 1.0;
        }
    }
}

// Used only when Quiz was completed successfully.
- (IBAction)endQuiz:(id)sender
{
    [self.timer invalidate];
}



- (void)setupUIForQuizQuestion:(QuizQuestion *)quizQuestion
{
    if (quizQuestion) {
        
        for (UIButton *button in self.answerButtons) {
            button.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
        }
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.questionLabel.alpha = 1.0;
            self.questionImageView.alpha = 1.0;
            for (UIButton *button in self.answerButtons) {
                button.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            for (UIButton *button in self.answerButtons) {
                button.enabled = YES;
            }
        }];
        
        
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
        
        [UIView animateWithDuration:0.1 animations:^{
            for (UIButton *button in self.answerButtons) {
                button.enabled = YES;
                button.alpha = 1.0;
            }
        } completion:nil];
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
    [self.timer invalidate];
    
    if (!self.currentQuizQuestion) return;
    
    if (sender.tag != self.currentQuizQuestion.correctAnswerIndex) {
        
        // Incorrect Answer
        sender.backgroundColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
        self.mistakeCount++;
        [self updateMistakeCountImages];
        
    }
    
    for (UIButton *button in self.answerButtons) {
        button.enabled = NO;
        if (button.tag == self.currentQuizQuestion.correctAnswerIndex) {
            button.backgroundColor = [UIColor colorWithRed:0.0 green:0.60 blue:0.0 alpha:1.0];
        }
    }

    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        
        for (UIButton *button in self.answerButtons) {
            
            button.alpha = button.tag == self.currentQuizQuestion.correctAnswerIndex ? 1.0 : 0.0;
        }
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.questionImageView.alpha = 0.0;
            self.questionLabel.alpha = 0.0;
            for (UIButton *button in self.answerButtons) {
                button.alpha = 0.0;
            }
            
        } completion:^(BOOL finished) {
            
            [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
        }];
        
    }];
    
}

#pragma mark - Navigation

- (IBAction)cancelQuiz:(id)sender {
    // Canceling Quiz
    [self.timer invalidate];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)exitCompletedQuiz:(id)sender
{
    [self.timer invalidate];
    [self performSegueWithIdentifier:@"unwindToQuizSelectionViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.timer invalidate];
}



@end
