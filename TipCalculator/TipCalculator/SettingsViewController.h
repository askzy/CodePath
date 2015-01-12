//
//  SettingsViewController.h
//  TipCalculator
//
//  Copyright (c) 2014 Ankur Sadhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
{
    NSArray *_pickerData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
