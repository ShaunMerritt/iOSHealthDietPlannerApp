//
//  SMFirstEditScreenForPatientDetailsViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SMFirstEditScreenForPatientDetailsViewController : UIViewController

@property (nonatomic, readwrite) BOOL isMale;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSString *userName;

@property (weak, nonatomic) IBOutlet UILabel *patientsWeightLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientsWeightTextField;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UITextField *heightInFeetTextField;
@property (weak, nonatomic) IBOutlet UITextField *heightInInchesTextField;
@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *maleSwitch;
@property (weak, nonatomic) IBOutlet UILabel *patientsAgeLabel;
@property (weak, nonatomic) IBOutlet UITextField *patientsAgeTextField;


@end
