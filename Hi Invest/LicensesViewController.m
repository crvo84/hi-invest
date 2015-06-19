//
//  LicensesViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "LicensesViewController.h"

@interface LicensesViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

#define LicensesCopyrights @{@"BEMSimpleLineGraph" : @"Copyright (c) 2014 Boris Emorine.\nCopyright (c) 2014 Sam Spencer.", @"XYPieChart" : @"Copyright (c) 2012 Xiaoyang Feng, XYStudio.cc", @"RESideMenu" : @"Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego).", @"BEMAnalogClock" : @"Copyright (c) 2014 Boris Emorine."}

#define LicensesMITLicense @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."


@implementation LicensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *separator = @"----------------";
    
    NSString *str = separator;
    
    for (NSString *key in LicensesCopyrights) {
        str = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@", str, key, LicensesCopyrights[key], LicensesMITLicense, separator];
    }
    
    NSDictionary *attributes = [self.textView.attributedText attributesAtIndex:0 effectiveRange:NULL];
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
}


@end
