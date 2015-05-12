//
//  SelectOrderingValueViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SelectOrderingValueViewController.h"
#import "SideMenuRootViewController.h"
#import "CompaniesViewController.h"
#import "RatiosKeys.h"

@interface SelectOrderingValueViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *sortingValueIdentifiers; // of NSString

@end

@implementation SelectOrderingValueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background color to the color set in the interface builder, then add the color again with a alpha component. This way only the super view will be transparent
    UIColor *viewColor = self.view.backgroundColor;
    self.view.backgroundColor = [viewColor colorWithAlphaComponent:0.7];
    
    // Set rounded corners for pickerView
    self.pickerView.layer.cornerRadius = 8; // Magic number
    self.pickerView.layer.masksToBounds = YES;
    
    // If there is a current sorting value selected, the pickerView will start selecting it.
    NSInteger row = [self.sortingValueIdentifiers indexOfObjectIdenticalTo:self.selectedIdentifier];
    if (row != NSNotFound) {
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
}

#pragma mark - Getters

- (NSArray *)sortingValueIdentifiers
{
    if (!_sortingValueIdentifiers) {
        _sortingValueIdentifiers = [FinancialSortingValuesIdentifiersArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return _sortingValueIdentifiers;
}

#pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.sortingValueIdentifiers count];
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sortingValueIdentifiers[row];
}


#pragma mark - Navigation

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self performSegueWithIdentifier:@"unwindFromSelectOrderingValueViewController" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"unwindFromSelectOrderingValueViewController"]) {
        NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
        NSString *selectedIdentifier = self.sortingValueIdentifiers[selectedIndex];
        self.selectedIdentifier = selectedIdentifier;
    }
}



















@end
