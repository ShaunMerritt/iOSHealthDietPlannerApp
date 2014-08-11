//
//  SMAddNewPatientViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAddNewPatientViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientsEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *patientsPhoneNumberTextField;

@property (weak, nonatomic) IBOutlet UILabel     *uniqueCodeLabel;
@property (weak, nonatomic) NSString        *uniqueCode;
@property (weak, nonatomic) NSString        *currentDoctorUsername;
@property (weak, nonatomic) NSString        *currentDoctorPassword;
@property (weak, nonatomic) NSString        *patientsPhoneNumber;

- (IBAction)createPatientButton:(id)sender;


@end
