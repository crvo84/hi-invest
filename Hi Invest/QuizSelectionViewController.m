//
//  QuizSelectionViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/14/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizSelectionViewController.h"
#import "QuizViewController.h"
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

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Category Cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Financial Ratio Definitions";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Financial Ratio Calculation";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Financial Statement Definitions";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"Stock Market Definitions";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return @"Select quiz";
    }
    
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
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
                QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
                Quiz *quiz;
                
                // CREATE QUIZ WITH OPTIONS GOT FROM ROW SELECTED
                if (indexPath.row == 0) {
                    
                    quiz = [quizGenerator getQuizWithType:QuizTypeFinancialRatioDefinitions andLevel:1];
                    
                } else if (indexPath.row == 1) {
                    
                    quiz = [quizGenerator getQuizWithType:QuizTypeFinancialRatioFormulas andLevel:1];
                    
                } else if (indexPath.row == 2) {
                    
                    quiz = [quizGenerator getQuizWithType:QuizTypeFinancialStatementDefinitions andLevel:1];
                    
                } else if (indexPath.row == 3) {
                    
                    quiz = [quizGenerator getQuizWithType:QuizTypeStockMarketDefinitions andLevel:1];
                    
                }
                
                [self prepareQuizViewController:(QuizViewController *)viewController withQuiz:quiz];
            }
        }
}

- (void)prepareQuizViewController:(QuizViewController *)quizViewController withQuiz:(Quiz *)quiz
{
    quizViewController.quiz = quiz;
    quizViewController.title = [NSString stringWithFormat:@"QUIZ  |  %@", quiz.title];
}

- (IBAction)unwindToQuizSelectionViewController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[QuizViewController class]]) {
//        NSInteger score = ((QuizViewController *)unwindSegue.sourceViewController).finalScore;
//        [self.game addScore:score]
        
    }
}
















@end
