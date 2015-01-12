//
//  TipViewController.m
//  TipCalculator
//
//  Copyright (c) 2014 Ankur Sadhoo. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"
#import "Constants.h"

@interface TipViewController ()
{
    NSArray *tipPercentages;
    BOOL roundingEnabled;
}
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipPercentageSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *numberPeopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *perPersonTotalTextField;
@property (weak, nonatomic) IBOutlet UIStepper *numberPeopleUpDownControl;

- (IBAction)onTap:(id)sender;
- (IBAction)onEditingChanged:(id)sender;
- (IBAction)onSettingsButton;
- (IBAction)onNumberPeopleUpdated:(id)sender;

- (void)updateModel;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Tip Calculator";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSInteger defaultTipIndex = [defaults integerForKey:DEFAULT_TIP_KEY];
   roundingEnabled = [defaults boolForKey:ROUNDING_SETTING_KEY];
    NSArray *tipValues = [defaults arrayForKey:TIP_VALUES_KEY];
    if (tipValues == nil) {
        tipValues = @[@(10), @(15), @(20)];
    }
    NSMutableArray *tipPercentageBuilder = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        [tipPercentageBuilder addObject:[[NSNumber alloc] initWithDouble:([tipValues[i] floatValue] / 100)]];
    }

    tipPercentages = tipPercentageBuilder;
    [self.tipPercentageSegmentedControl setSelectedSegmentIndex:defaultTipIndex];
    [self.tipPercentageSegmentedControl setTitle:[[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[0]] forSegmentAtIndex:0];
    [self.tipPercentageSegmentedControl setTitle:[[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[1]] forSegmentAtIndex:1];
    [self.tipPercentageSegmentedControl setTitle:[[NSString alloc] initWithFormat:PERCENT_FORMAT, tipValues[2]] forSegmentAtIndex:2];
    [self updateModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateModel];
}

- (void)updateModel {
    float billAmount = [self.billTextField.text floatValue];
    float tipPercentage = [tipPercentages[self.tipPercentageSegmentedControl.selectedSegmentIndex] floatValue];
    float tipAmount = billAmount * tipPercentage;
    float totalAmount = billAmount + tipAmount;
    if (roundingEnabled) {
        totalAmount = (int)totalAmount; // rounding down as tip inclusion is higher than bill amount as it is.
    }
    self.numberPeopleLabel.text = [[NSString alloc] initWithFormat:
                                   @"%0.0f", self.numberPeopleUpDownControl.value];
    float amountPerPerson = totalAmount / self.numberPeopleUpDownControl.value;
    self.tipTextField.text = [[NSString alloc] initWithFormat:
                              @"$ %0.2f", tipAmount];
    self.totalTextField.text = [[NSString alloc] initWithFormat:
                                (roundingEnabled ? @"$ %0.0f" : @"$ %0.2f"), totalAmount];
    self.perPersonTotalTextField.text = [[NSString alloc] initWithFormat:
                              @"$ %0.2f", amountPerPerson];
}

- (IBAction)onEditingChanged:(id)sender {
    [self updateModel];
}

- (IBAction)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (IBAction)onNumberPeopleUpdated:(id)sender {
    [self updateModel];
}

@end
