//
//  SettingsViewController.m
//  TipCalculator
//
//  Copyright (c) 2014 Ankur Sadhoo. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"

@interface SettingsViewController ()
{
    NSInteger defaultTipIndex;
    BOOL roundingEnabled;
    NSArray *tipValues;
    NSArray *tipFormattedValues;
}

@property (weak, nonatomic) IBOutlet UILabel *leastPercentSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *moderatePercentSettingLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxPercentSettingLabel;
@property (weak, nonatomic) IBOutlet UISwitch *roundingEnabledSwitch;
@property (weak, nonatomic) IBOutlet UILabel *preselectedSettingValue;
@property (weak, nonatomic) IBOutlet UILabel *leastPctSettingValue;
@property (weak, nonatomic) IBOutlet UILabel *moderatePctSettingValue;
@property (weak, nonatomic) IBOutlet UILabel *maxPctSettingValue;
@property (weak, nonatomic) IBOutlet UIStepper *leastPctUpDownControl;
@property (weak, nonatomic) IBOutlet UIStepper *moderatePctUpDownControl;
@property (weak, nonatomic) IBOutlet UIStepper *maxPctUpDownControl;
- (IBAction)onRoundingToggle:(id)sender;
- (IBAction)onTipStepperInvoked:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pickerData = @[@"Least", @"Moderate", @"Maximum"];
    self.leastPercentSettingLabel.text = _pickerData[0];
    self.moderatePercentSettingLabel.text = _pickerData[1];
    self.maxPercentSettingLabel.text = _pickerData[2];
    self.roundingEnabledSwitch.onTintColor = [UIColor whiteColor];
    [self loadSettings];
}

- (IBAction)onRoundingToggle:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.roundingEnabledSwitch.on forKey:ROUNDING_SETTING_KEY];
    [defaults synchronize];
    [self loadSettings];
}

- (IBAction)onTipStepperInvoked:(id)sender {
    NSInteger index = (sender == self.leastPctUpDownControl) ? 0 : (sender == self.moderatePctUpDownControl) ? 1 : 2;
    UIStepper *stepper = sender;
    BOOL isIncreasing = ([tipValues[index] floatValue] < stepper.value);
    if (stepper.value < MIN_TIP || stepper.value > MAX_TIP) {
        stepper.value = [tipValues[index] floatValue];
        return;
    }
    
    NSMutableArray *updatedTipValues = [[NSMutableArray alloc] init];
    [updatedTipValues addObjectsFromArray:tipValues];
    NSNumber *newValue = [[NSNumber alloc]initWithDouble:stepper.value];
    
    [updatedTipValues replaceObjectAtIndex:index withObject:newValue];
    if (isIncreasing) {
        for (int i = index + 1; i < 3; i++) {
            if ([tipValues[i] floatValue] < stepper.value) {
                [updatedTipValues replaceObjectAtIndex:i withObject:newValue];
            }
        }
    } else {
        for (int i = index - 1; i >= 0; i--) {
            if ([tipValues[i] floatValue] > stepper.value) {
                [updatedTipValues replaceObjectAtIndex:i withObject:newValue];
            }
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:updatedTipValues forKey:TIP_VALUES_KEY];
    [defaults synchronize];
    [self loadSettings];
}


- (void)loadSettings {
    // Load saved values
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaultTipIndex = [defaults integerForKey:DEFAULT_TIP_KEY]; // default to 0 (if non-existent) is fine
    roundingEnabled = [defaults boolForKey:ROUNDING_SETTING_KEY]; // default to NO is fine
    tipValues = [defaults arrayForKey:TIP_VALUES_KEY];
    if (tipValues == nil) {
        tipValues = @[@(10), @(15), @(20)];
    }
    tipFormattedValues = @[[[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[0]],
                           [[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[1]],
                           [[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[2]]];
    
    // Initialize based on saved values
    [self.picker selectRow:defaultTipIndex inComponent:0 animated:NO];
    self.roundingEnabledSwitch.on = roundingEnabled;
    self.leastPctSettingValue.text = tipFormattedValues[0];
    self.moderatePctSettingValue.text = tipFormattedValues[1];
    self.maxPctSettingValue.text = tipFormattedValues[2];
    self.preselectedSettingValue.text = tipFormattedValues[defaultTipIndex];
    self.leastPctUpDownControl.value = [tipValues[0] floatValue];
    self.moderatePctUpDownControl.value = [tipValues[1] floatValue];
    self.maxPctUpDownControl.value = [tipValues[2] floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = _pickerData[row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:row forKey:DEFAULT_TIP_KEY];
    [defaults synchronize];
    [self loadSettings];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
