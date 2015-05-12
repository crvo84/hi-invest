//
//  QuizSelectionViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/14/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "QuizSelectionViewController.h"
#import "QuizViewController.h"
#import "QuizQuestionGenerator.h"

@interface QuizSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QuizSelectionViewController

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Category Cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Financial Ratios";
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return @"Definitions";
    }
    
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
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
                NSMutableArray *questions;
                
                if (indexPath.row == 0) {
                    questions = [QuizQuestionGenerator generateTermDefinitionQuestions];

                }
                
                [self prepareQuizViewController:(QuizViewController *)viewController withInvestingGame:self.game withArrayOfQuestions:questions withCategoryName:cell.textLabel.text];
            }
        }
}

- (void)prepareQuizViewController:(QuizViewController *)quizViewController withInvestingGame:(InvestingGame *)game withArrayOfQuestions:(NSMutableArray *)questions withCategoryName:(NSString *)categoryName
{
    
    quizViewController.game = game;
    quizViewController.questions = questions;
    quizViewController.title = [NSString stringWithFormat:@"QUIZ  |  %@", categoryName];
}

- (IBAction)unwindToQuizSelectionViewController:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[QuizViewController class]]) {
//        NSInteger score = ((QuizViewController *)unwindSegue.sourceViewController).finalScore;
//        [self.game addScore:score]
        
    }
}
















@end
