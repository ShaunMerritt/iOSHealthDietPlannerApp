//
//  SMEditPatientDietViewController.h
//  Elu
//
//  Created by Shaun Merritt on 7/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMEditPatientDietViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *patientsNameLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *thePickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *activitySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *weightSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *patientWeightTextField;
@property (weak, nonatomic) IBOutlet UISwitch *maleSwitch;

@property (strong, nonatomic) NSArray *oneColumnList;
@property (strong, nonatomic) NSArray *secondColumnList;
@property (strong, nonatomic) NSString *currentFirstColumn;
@property (strong, nonatomic) NSString *currentSecondColumn;

@property (strong, nonatomic) NSMutableDictionary *capsAndRegs;

- (IBAction)saveAsCapPressed:(id)sender;
- (IBAction)switchValueChanged:(id)sender;


@end
