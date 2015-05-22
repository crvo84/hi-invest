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
#import "Quiz.h"

@interface QuizSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QuizSelectionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    [self.tableView reloadData];
}

#pragma mark - Quizzes Info


#pragma mark - Getters


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return QuizTypeCount - 1; // Remove the "-1" when all QuizTypes are implemented in QuizGenerator
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizTableViewCell *quizCell = [self.tableView dequeueReusableCellWithIdentifier:@"Quiz Cell"];
    
    QuizType quizType = indexPath.row;
    NSInteger quizTypeLevel = [self.userAccount currentQuizLevelForQuizType:quizType];
    
    QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
    NSDictionary *quizInfo = [quizGenerator quizInfoWithType:quizType andLevel:quizTypeLevel];
    
    if (quizInfo) {
        
        quizCell.accessoryType = UITableViewCellAccessoryNone;
        quizCell.titleLabel.text = quizInfo[QuizInfoTitleKey];
        quizCell.levelLabel.text = [NSString stringWithFormat:@"Level %ld", (long)quizTypeLevel];
        quizCell.numberOfQuestionsLabel.hidden = NO;
  
    } else { // No new level available
        
        quizCell.levelLabel.hidden = YES;
        quizCell.accessoryType = UITableViewCellAccessoryCheckmark;
        quizCell.titleLabel.text = [quizGenerator titleForQuizType:quizType];
        
    }
    
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
            NSInteger quizTypeLevel = [self.userAccount currentQuizLevelForQuizType:quizType];
            NSInteger maxQuizTypeLevelAvailable = [quizGenerator maximumLevelForQuizType:quizType];
            if (quizTypeLevel > maxQuizTypeLevelAvailable) {
                quizTypeLevel = maxQuizTypeLevelAvailable;
            }
            
            Quiz *quiz = [quizGenerator getQuizWithType:quizType andLevel:quizTypeLevel];
            
            [self prepareQuizViewController:(QuizViewController *)viewController withQuiz:quiz withQuizType:quizType];
        }
    }
}

- (void)prepareQuizViewController:(QuizViewController *)quizViewController withQuiz:(Quiz *)quiz
                     withQuizType:(QuizType)quizType
{
    quizViewController.quiz = quiz;
    quizViewController.quizType = quizType;
    quizViewController.title = [NSString stringWithFormat:@"QUIZ  |  %@", quiz.title];
}

// Used only when quiz was completed successfully
- (IBAction)unwindToQuizSelectionViewController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[QuizViewController class]]) {
        UIViewController *viewController = ((QuizViewController *)unwindSegue.sourceViewController);
        if ([viewController isKindOfClass:[QuizViewController class]]) {
            QuizViewController *quizViewController = (QuizViewController *)viewController;
            [self.userAccount increaseQuizLevelForQuizType:quizViewController.quizType];
        }
    }
}
















@end
