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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load CompanyCell NIB file
    UINib *nib = [UINib nibWithNibName:@"QuizTableViewCell" bundle:nil];
    // Register the cell NIB
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Quiz Cell"];
}

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
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuizTableViewCell *quizCell = [self.tableView dequeueReusableCellWithIdentifier:@"Quiz Cell"];

    QuizType quizType;
    
    if (indexPath.row == 0) {
        quizType = QuizTypeFinancialRatioDefinitions;
        
    } else if (indexPath.row == 1) {
        quizType = QuizTypeFinancialRatioFormulas;
        
    } else if (indexPath.row == 2) {
        quizType = QuizTypeFinancialRatioDefinitionsAndFormulas;
        
    } else if (indexPath.row == 3) {
        quizType = QuizTypeFinancialStatementDefinitions;
        
    } else if (indexPath.row == 4) {
        quizType = QuizTypeStockMarketDefinitions;
        
    } else if (indexPath.row == 5) {
        quizType = QuizTypeAllDefinitions;
    }
    
    QuizGenerator *quizGenerator = [[QuizGenerator alloc] init];
    NSDictionary *quizInfo = [quizGenerator quizInfoWithType:quizType andLevel:1];
    
    quizCell.titleLabel.text = quizInfo[QuizInfoTitleKey];
    quizCell.numberOfQuestionsLabel.text = [NSString stringWithFormat:@"Questions: %@", quizInfo[QuizInfoNumberOfQuestionsKey]];
    quizCell.pointsLabel.text = [NSString stringWithFormat:@"Points: %@", quizInfo[QuizInfoMaxScoreKey]];
    quizCell.mistakesAllowedLabel.hidden = YES;
    quizCell.secondsPerQuestionLabel.hidden = YES;
    
    return quizCell;
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
    return 83;
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
                    quiz = [quizGenerator getQuizWithType:QuizTypeFinancialRatioDefinitionsAndFormulas andLevel:1];
                    
                } else if (indexPath.row == 3) {
                    quiz = [quizGenerator getQuizWithType:QuizTypeFinancialStatementDefinitions andLevel:1];
                    
                } else if (indexPath.row == 4) {
                    quiz = [quizGenerator getQuizWithType:QuizTypeStockMarketDefinitions andLevel:1];
                    
                } else if (indexPath.row == 5) {
                    quiz = [quizGenerator getQuizWithType:QuizTypeAllDefinitions andLevel:1];
                    
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
