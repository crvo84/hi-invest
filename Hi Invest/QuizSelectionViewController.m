//
//  QuizSelectionViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/14/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizSelectionViewController.h"
#import "QuizViewController.h"
#import "QuizTableViewCell.h"
#import "QuizGenerator.h"
#import "UserAccount.h"
#import "DefaultColors.h"
#import "Quiz.h"

@interface QuizSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QuizSelectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateUI]; // Done here for progress bar animation
}

- (void)updateUI
{
    for (int quizType = 0; quizType < QuizTypeCount; quizType++) { // Because QuizTypeCount is an enum at Quiz.h
        
        QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
        NSInteger quizTypeSuccessfulQuizzes = [self.userAccount successfulQuizzesForQuizType:quizType];
        NSInteger maxQuizTypeDifficultyLevel = [quizGenerator maximumDifficultyLevelForQuizType:quizType];
        
        QuizTableViewCell *quizCell = (QuizTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:quizType inSection:0]];
        
        if (quizTypeSuccessfulQuizzes <= maxQuizTypeDifficultyLevel) {
            
            quizCell.accessoryType = UITableViewCellAccessoryNone;
            quizCell.progressView.hidden = NO;
            
            // maxQuizTypeDifficultyLevel + 1 because it has zero based index
            [quizCell.progressView setProgress:((CGFloat)quizTypeSuccessfulQuizzes) / (maxQuizTypeDifficultyLevel + 1) animated:YES];
            
        } else {
            
            quizCell.accessoryType = UITableViewCellAccessoryCheckmark;
            quizCell.progressView.hidden = YES;
        }
    }
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return QuizTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizTableViewCell *quizCell = [self.tableView dequeueReusableCellWithIdentifier:@"Quiz Cell"];
    
    QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
    
    QuizType quizType = indexPath.row;
    
    quizCell.titleLabel.text = [quizGenerator titleForQuizType:quizType];
    
    UIColor *progressColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
    [quizCell.progressView setProgressTintColor:progressColor];
    
    return quizCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select Quiz";
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselects the table view cell so it wont be selected when returning from the segued view controller
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [((UINavigationController *)viewController).viewControllers firstObject];
    }
    
    if ([viewController isKindOfClass:[QuizViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            
            UITableViewCell *cell = sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            // CREATE QUIZ WITH OPTIONS GOT FROM ROW SELECTED
            QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
            QuizType quizType = indexPath.row;
            
            NSInteger quizDifficultyLevel = [self.userAccount successfulQuizzesForQuizType:quizType];
            NSInteger maxQuizTypeLevelAvailable = [quizGenerator maximumDifficultyLevelForQuizType:quizType];
            
            BOOL quizAlreadyDone = NO;
            
            if (quizDifficultyLevel > maxQuizTypeLevelAvailable) {
                quizDifficultyLevel = maxQuizTypeLevelAvailable;
                quizAlreadyDone = YES;
            }
            
            Quiz *quiz = [quizGenerator getQuizWithType:quizType andDifficultyLevel:quizDifficultyLevel];
            
            [self prepareQuizViewController:(QuizViewController *)viewController withQuiz:quiz quizType:quizType quizAlreadyDone:quizAlreadyDone];
        }
    }
}

- (void)prepareQuizViewController:(QuizViewController *)quizViewController withQuiz:(Quiz *)quiz
                         quizType:(QuizType)quizType quizAlreadyDone:(BOOL)quizAlreadyDone
{
    quizViewController.quiz = quiz;
    quizViewController.quizType = quizType;
    quizViewController.quizAlreadyDone = quizAlreadyDone;
    quizViewController.title = [NSString stringWithFormat:@"QUIZ  |  %@", quiz.title];
}

// Used only when quiz was completed successfully
- (IBAction)unwindToQuizSelectionViewController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[QuizViewController class]]) {
        UIViewController *viewController = ((QuizViewController *)unwindSegue.sourceViewController);
        if ([viewController isKindOfClass:[QuizViewController class]]) {
            QuizViewController *quizViewController = (QuizViewController *)viewController;
            if (quizViewController.succesfulQuiz && !quizViewController.quizAlreadyDone) {
                [self.userAccount increaseSuccessfulQuizzesForQuizType:quizViewController.quizType];
            }
        }
    }
}

#pragma mark - Getters















@end
