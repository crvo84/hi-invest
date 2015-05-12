//
//  TimeSimulationViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/4/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "TimeSimulationViewController.h"
#import "BEMAnalogClockView.h"
#import "DefaultColors.h"

@interface TimeSimulationViewController () <BEMAnalogClockDelegate>
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet BEMAnalogClockView *clockView;
@property (nonatomic) BOOL cancelledManually;
@end

@implementation TimeSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // If user does not touch the screen while the clock is animating, the view controller will eventually perform an automatic unwind segue
    self.cancelledManually = NO;
    
    self.view.backgroundColor = [DefaultColors translucentDarkBackgroundColor];
    
    // BEMAnalogClockView Configuration
    self.clockView.borderColor = [UIColor whiteColor];
    self.clockView.borderWidth = 3;
    self.clockView.faceBackgroundColor = [UIColor whiteColor];
    self.clockView.faceBackgroundAlpha = 0.0;
    self.clockView.digitFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.clockView.digitColor = [UIColor whiteColor];
    self.clockView.enableDigit = YES;
    self.clockView.secondHandAlpha = 0.0;
    
    self.clockView.hours = 12;
    self.clockView.minutes = 60;
    
    NSString *timePeriodStr;
    if (self.daysNum <= 1) timePeriodStr = @"one day";
    else if (self.daysNum <= 7) timePeriodStr = @"one week";
    else if (self.daysNum <= 31) timePeriodStr = @"one month";
    else if (self.daysNum <= 180) timePeriodStr = @"six months";
    else if (self.daysNum <= 365) timePeriodStr = @"one year";
    else timePeriodStr = @"";

    self.daysLabel.text = [NSString stringWithFormat:@"Let's wait %@...", timePeriodStr];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animateBEMAnalogClockView:self.clockView forNumberOfSeconds:3];
}

#pragma mark - Update UI

- (void)updateUI
{
    [self.clockView reloadClock];
}

//-----------------------/
/* Device Auto-Rotation */
//-----------------------/

#pragma mark - Device Rotation

- (void)awakeFromNib
{
    // Adds self as observer for device orientation changes
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    // Removes self as observer from notification center
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationChanged:(NSNotification *)notification
{
    // Need to update UI after rotation, so the pieChart will redraw itself within the pieChart view bounds
    [self updateUI];
}


#pragma mark - Animation

#define SecondsPerClockMovement 0.25

- (void)animateBEMAnalogClockView:(BEMAnalogClockView *)clockView forNumberOfSeconds:(double)seconds
{
    NSInteger clockMovements = seconds / SecondsPerClockMovement;
    
    for (int i = 0; i < clockMovements; i++) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, i * SecondsPerClockMovement * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self ramdomClockAnimation];
        });
        
    }
    
    // Block executed when clock movements are finished
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, clockMovements * SecondsPerClockMovement * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [UIView animateWithDuration:SecondsPerClockMovement animations:^{
            self.daysLabel.alpha = 0;
        }];
    });
    
    // Block executed when label dissapears
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (clockMovements + 1) * SecondsPerClockMovement * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [UIView animateWithDuration:SecondsPerClockMovement animations:^{
            self.daysLabel.text = @"Done!";
            self.daysLabel.alpha = 1;
        }];
    });
    
    // Block executed after the label appears again
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (clockMovements + 3) * SecondsPerClockMovement * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if (!self.cancelledManually) {
            // If user didn't touch the screen before this block is executed
            [self performSegueWithIdentifier:@"unwindFromTimeSimulationViewController" sender:self];
        }
    });
}



- (void)ramdomClockAnimation
{
    self.clockView.hours = arc4random() % 12;
    self.clockView.minutes = arc4random() % 60;

    [self.clockView updateTimeAnimated:YES];
}


#pragma mark - BEMAnalogClockView Delegate

- (CGFloat)analogClock:(BEMAnalogClockView *)clock graduationLengthForIndex:(NSInteger)index {
    if (!(index % 5) == 1) { // Every 5 graduation will be longer.
        return 20;
    } else {
        return 5;
    }
}

- (UIColor *)analogClock:(BEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    return [UIColor whiteColor];
}

#pragma mark - Dismissing View Controller

// FOR DEBUGGING
// Call cancel method when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.cancelledManually = YES; // If user touches the screen, automatic unwind segue is cancelled
    [self performSegueWithIdentifier:@"unwindFromTimeSimulationViewController" sender:self];

}












@end
