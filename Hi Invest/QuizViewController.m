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
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIView *initialSubview;
@property (weak, nonatomic) IBOutlet UILabel *initialInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialCountdownLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quizAlreadyDoneImageView;
// Final Subview Outlets
@property (weak, nonatomic) IBOutlet UIView *finalSubview;
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;
@property (weak, nonatomic) IBOutlet UIButton *finalSubviewButton;
@property (weak, nonatomic) IBOutlet UIImageView *finalImageView;
// Quiz Outlets
@property (weak, nonatomic) IBOutlet UIView *timerBarSuperview;
@property (strong, nonatomic) UIView *timerBarView;
@property (weak, nonatomic) IBOutlet UIImageView *mistakesLeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *mistakesLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;
@property (nonatomic) NSUInteger mistakeCount;
// Quiz View Controller Dismissing
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelQuizBarButtonItem;

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
    if (self.quizAlreadyDone) {
        self.quizAlreadyDoneImageView.image = [[UIImage imageNamed:@"correctB"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.quizAlreadyDoneImageView.tintColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
        self.quizAlreadyDoneImageView.hidden = NO;
    } else {
        self.quizAlreadyDoneImageView.hidden = YES;
    }

    // QUIZ SETUP
    
    self.succesfulQuiz = NO;
    
    // Mistake count
    self.mistakeCount = 0;
    // Image will take UIImageView tint color. Set on interface builder
    self.mistakesLeftImageView.image = [[UIImage imageNamed:@"ninjaEmoticon22x22"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self updateMistakesLeft];
    
    // Answer Buttons
    for (UIButton *answerButton in self.answerButtons) {
        
        answerButton.layer.cornerRadius = 3;
        answerButton.layer.masksToBounds = YES;
        answerButton.titleLabel.minimumScaleFactor = 0.7;
        answerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        answerButton.alpha = 0.0;
        answerButton.enabled = NO;
    }
    
    // Question views
    [self updateQuestionCounter];
    self.questionImageView.alpha = 0.0;
    self.questionLabel.alpha = 0.0;
    
    // FINAL SUBVIEW SETUP
    self.initialSubview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.90];
    self.finalSubview.hidden = YES;
    self.finalSubview.alpha = 0.0;
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

- (void)updateMistakesLeft
{
    NSInteger mistakesLeft = self.quiz.mistakesAllowed - self.mistakeCount;
    self.mistakesLeftLabel.text = [NSString stringWithFormat:@"x%ld", (long)MAX(mistakesLeft, 0)];
}

- (void)updateQuestionCounter
{
    self.questionCounterLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.quiz.nextQuizQuestionIndex, (unsigned long)[self.quiz.quizQuestions count]];
}

// Pre condition: All Answer UIButtons and questions UIViews must have alpha = 0.0. UIButtons must also be disabled
- (void)setupUIForQuizQuestion:(QuizQuestion *)quizQuestion
{
    if (quizQuestion && self.mistakeCount <= self.quiz.mistakesAllowed) {
        
        [self updateQuestionCounter];
        
        self.currentQuizQuestion = quizQuestion;
        
        for (UIButton *button in self.answerButtons) {
            button.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
        }
        
        BOOL showQuestionLabel;
        BOOL showQuestionImageView;
        if (quizQuestion.questionType == QuizQuestionTypeImageQuestionImageAnswers || quizQuestion.questionType == QuizQuestionTypeImageQuestionTextAnswers) {
            
            showQuestionLabel = NO;
            showQuestionImageView = YES;
            self.questionImageView.image = [[UIImage imageNamed:quizQuestion.question] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
        } else {
            
            showQuestionLabel = YES;
            showQuestionImageView = NO;
            self.questionLabel.text = quizQuestion.question;
            
        }
        
        if ([quizQuestion.answers count] == [self.answerButtons count]) {
            for (int i = 0; i < [self.answerButtons count]; i++) {
                
                UIButton *answerButton = self.answerButtons[i];
                [answerButton setTitle:quizQuestion.answers[i] forState:UIControlStateNormal];
            }
        }
        
        //Create Timer Bar
        self.timerBarView = [[UIView alloc] initWithFrame:self.timerBarSuperview.bounds];
        self.timerBarView.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
        self.timerBarView.alpha = 0.0;
        [self.timerBarSuperview addSubview:self.timerBarView];
        
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            self.questionLabel.alpha = showQuestionLabel ? 1.0 : 0.0;
            self.questionImageView.alpha = showQuestionImageView ? 1.0 : 0.0;
            for (UIButton *button in self.answerButtons) {
                button.alpha = 1.0;
            }
            self.timerBarView.alpha = 1.0;
        } completion:^(BOOL finished) {
            for (UIButton *button in self.answerButtons) {
                button.enabled = YES;
            }
        }];
        
        [UIView animateWithDuration:self.quiz.secondsPerQuestion delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
                self.timerBarView.frame = CGRectMake(self.timerBarSuperview.bounds.origin.x, self.timerBarSuperview.bounds.origin.y, 0.0, self.timerBarSuperview.bounds.size.height);
            
        } completion:^(BOOL finished) {
            
            if (finished) { // Only if animation finished (if time is out only)
                [self.timerBarView removeFromSuperview];
                self.timerBarView = nil;
                
                self.mistakeCount++;
                [self updateMistakesLeft];
                
                [self setupUIForQuizQuestion:[self.quiz getNewQuizQuestion]];
            }
        }];
    } else {
        // Finished game
        self.succesfulQuiz = self.mistakeCount <= self.quiz.mistakesAllowed;
        [self finishQuiz];
    }
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    if (!self.currentQuizQuestion) return;
    
    // Cancel timer Bar. (To remove view and cancel its animation completion block)
    [self.timerBarView.layer removeAllAnimations];
    [self.timerBarView removeFromSuperview];
    self.timerBarView = nil;
    
    if (sender.tag != self.currentQuizQuestion.correctAnswerIndex) {
        
        // Incorrect Answer
        sender.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
        self.mistakeCount++;
        [self updateMistakesLeft];
        
    }
    
    for (UIButton *button in self.answerButtons) {
        button.enabled = NO;
        if (button.tag == self.currentQuizQuestion.correctAnswerIndex) {
            button.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
        }
    }

    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
        
        for (UIButton *button in self.answerButtons) {
            
            button.alpha = button.tag == self.currentQuizQuestion.correctAnswerIndex ? 1.0 : 0.0;
        }
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 delay:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
            
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

// Pre condition: finalSubview must be set to hidden and alpha = 0.0. Final subview button disabled
- (void)finishQuiz
{
    self.cancelQuizBarButtonItem.enabled = NO;
    
    self.finalSubview.hidden = NO;
    
    // Final Label
    self.finalLabel.text = self.succesfulQuiz ? @"Well done!" : @"Maybe next time!";
    
    // Final Image
    UIImage *finalImage;
    UIColor *finalImageColor;
    if (self.succesfulQuiz) {
        finalImage = [[UIImage imageNamed:@"correctB"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        finalImageColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
    } else {
        finalImage = [[UIImage imageNamed:@"incorrectB"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        finalImageColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    }
    self.finalImageView.image = finalImage;
    self.finalImageView.tintColor = finalImageColor;
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.finalSubview.alpha = 1.0;
        
    } completion:nil];
    
}

#pragma mark - Navigation

- (IBAction)cancelQuiz:(id)sender {
    // Canceling Quiz
    [self.timer invalidate]; // In case user cancel the quiz while in initial countdown
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil]; // No need to save anything
}

- (IBAction)exitCompletedQuiz:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToQuizSelectionViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Send user info to UserAccount here
}



@end
