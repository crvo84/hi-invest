//
//  SavedGamesViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SavedGamesViewController.h"
#import "ManagedObjectContextCreator.h"
#import <CoreData/CoreData.h>
#import "InvestingGame.h"
#import "GameTableViewCell.h"
#import "DefaultColors.h"
#import "UserAccount.h"
#import "GameInfo+Create.h"

@interface SavedGamesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;
@property (strong, nonatomic) NSArray *gameInfoManagedObjects; // of GameInfo
@property (strong, nonatomic) NSManagedObjectContext *gameInfoManagedObjectsContext;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation SavedGamesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    BOOL noInfo = [self.gameInfoManagedObjects count] == 0;
    self.noInfoLabel.hidden = !noInfo;
    self.tableView.hidden = noInfo;
}

- (IBAction)editTableView:(UIBarButtonItem *)sender
{
    if ([self.tableView isEditing]) {
        [sender setTitle:@"Edit"];
        [self.tableView setEditing:NO animated:YES];
        
    } else {
        [sender setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
    }
    
    [self checkForCoreDataMemoryleak]; // FOR DEBUGGING
}

// For debugging
- (void)checkForCoreDataMemoryleak
{
    NSManagedObjectContext *context = self.gameInfoManagedObjectsContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HistoricalValue"];
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
    NSArray *matches2 = [context executeFetchRequest:request2 error:nil];
    
    NSFetchRequest *request3 = [NSFetchRequest fetchRequestWithEntityName:@"Ticker"];
    NSArray *matches3 = [context executeFetchRequest:request3 error:nil];
    
    NSLog(@"%ld HistoricalValues left", (unsigned long)[matches count]);
    NSLog(@"%ld Transactions left", (unsigned long)[matches2 count]);
    NSLog(@"%ld Tickers left", (unsigned long)[matches3 count]);
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.gameInfoManagedObjects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameTableViewCell *gameCell = [self.tableView dequeueReusableCellWithIdentifier:@"Game Cell"];
    
    GameInfo *gameInfo = self.gameInfoManagedObjects[indexPath.section];
    
    
    // TITLE LABLE
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *currentDayStr = [self.numberFormatter stringFromNumber:gameInfo.currentDay];
    NSString *numberOfDaysStr = [self.numberFormatter stringFromNumber:gameInfo.numberOfDays];
    gameCell.titleLabel.text = [NSString stringWithFormat:@"Day %@/%@", currentDayStr, numberOfDaysStr];
    
    
    // SUBTITLE LABEL
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[gameInfo.currentDay integerValue] > 365 ? @"Ann. Return: " : @"Return: " ];
    
    [attributedStr appendAttributedString:[DefaultColors attributedStringForReturn:[gameInfo.currentReturn doubleValue] forDarkBackground:NO]];
    
    NSString *disguisedStr = [gameInfo.disguiseCompanies boolValue] ? @" | Disguised" : @"";
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:disguisedStr]];
    
    gameCell.subtitleLabel.attributedText = attributedStr;
    
    
    // CURRENT GAME OR LOAD BUTTON
    GameInfo *currentGameInfo = self.userAccount.currentInvestingGame.gameInfo;
    BOOL isCurrentGameInfo = [gameInfo.uniqueId isEqualToString:currentGameInfo.uniqueId];

    gameCell.currentGameLabel.hidden = !isCurrentGameInfo;
//    gameCell.loadButton.hidden = isCurrentGameInfo;
    
    // LOAD BUTTON TAG
//    gameCell.loadButton.tag = indexPath.section;
    
    return gameCell;
}

#pragma mark - UITableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    GameInfo *gameInfo = self.gameInfoManagedObjects[section];
    
    return gameInfo.scenarioName;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GameInfo *gameInfoToDelete = self.gameInfoManagedObjects[indexPath.section];
        NSString *userId = gameInfoToDelete.userId;
        NSString *scenarioFilename = gameInfoToDelete.scenarioFilename;
        
        // Check UserAccount currentInvestingGame. If it has the same GameInfo that is going to be deleted, exit the game first
        NSString *currentInvestingGameUserId = self.userAccount.currentInvestingGame.gameInfo.userId;
        NSString *currentInvestingGameScenarioFilename = self.userAccount.currentInvestingGame.gameInfo.scenarioFilename;
        if ([userId isEqualToString:currentInvestingGameUserId] && [scenarioFilename isEqualToString:currentInvestingGameScenarioFilename]) {
            [self.userAccount exitCurrentInvestingGame];
        }
        
        [GameInfo removeExistingGameInfoWithScenarioFilename:scenarioFilename
                                                  withUserId:userId
                                    intoManagedObjectContext:self.gameInfoManagedObjectsContext];
        
        self.gameInfoManagedObjects = nil;

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self updateUI];
    }
}

#pragma mark - Loading Games

//- (IBAction)loadGameButtonPressed:(UIButton *)sender
//{
//    GameInfo *gameInfo = self.gameInfoManagedObjects[sender.tag];
//    
//    self.userAccount.selectedScenarioFilename = gameInfo.scenarioFilename;
//    
//    [self.userAccount loadInvestingGameWithGameInfo:gameInfo];
//    
//    [self.tableView reloadData];
//    [self updateUI];
//}

#pragma mark - Getters

- (NSArray *)gameInfoManagedObjects
{
    if (!_gameInfoManagedObjects) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameInfo"];
        request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", [self.userAccount userId]];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"scenarioName" ascending:YES]];
        
        _gameInfoManagedObjects = [self.gameInfoManagedObjectsContext executeFetchRequest:request error:nil];
    }
    
    return _gameInfoManagedObjects;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = self.userAccount.localeDefault;
        _numberFormatter.maximumFractionDigits = 2;
    }
    
    return _numberFormatter;
}

- (NSManagedObjectContext *)gameInfoManagedObjectsContext
{
    if (!_gameInfoManagedObjectsContext) {
        _gameInfoManagedObjectsContext = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    }
    
    return _gameInfoManagedObjectsContext;
}


@end
