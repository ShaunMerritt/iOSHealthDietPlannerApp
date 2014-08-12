//
//  SMAddNewPatientViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAddNewPatientViewController.h"

@interface SMAddNewPatientViewController ()

@end

@implementation SMAddNewPatientViewController
@synthesize uniqueCode;

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - IBActions
- (IBAction)createPatientButton:(id)sender {
    
    [self genRandStringLength:5];
    [self createNewPatient];
    
}

#pragma mark - HelperMethods
- (NSString *)genRandStringLength:(int)len {
    
    // Create string with all possible
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    NSString *finalRandomString = [NSString stringWithString:randomString];
    NSLog(@"%@", finalRandomString);
    uniqueCode = finalRandomString;
    return finalRandomString;
}


-(void) createNewPatient {
    
    // Store current doctors info for login later
    self.currentDoctorUsername = [PFUser currentUser].username;
    
    // Create new patient details and save them to the user
    PFUser *newPatient  = [PFUser user];
    newPatient.username = self.patientsEmailTextField.text;
    newPatient.email    = self.patientsEmailTextField.text;
    newPatient.password = [self genRandStringLength:5];
    
    // Save patients phone number to variable then convert it to mutable string.
    self.patientsPhoneNumber = self.patientsPhoneNumberTextField.text;
    //NSMutableString *patientsNumber = [NSMutableString stringWithString:self.patientsPhoneNumber];
    
    // Call cloud code function "inviteUser" with paramameters
    [PFCloud callFunctionInBackground:@"inviteUser"
                       withParameters: @{@"email": newPatient.email, @"password": newPatient.password, @"doctorCode": newPatient.password, @"phoneNumberForPatient": self.patientsPhoneNumberTextField.text, @"doctorUserName": [PFUser currentUser].username, @"doctorIdentifier": [PFUser currentUser].objectId}
                                block:^(NSString *object, NSError *error) {
                                    if (!error) {
                                        // Everything went well, the user was created. The returned object is the password.
                                        NSLog(@"%@",object);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                        self.uniqueCodeLabel.text = newPatient.password;
                                    }
                                    else {
                                        // Handle errror here
                                        NSLog(@"%@, %@", error,[error userInfo]);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                    }
                                }];

    // Use this to check the doctor is still the signed in patient.
    NSLog(@"%@", [PFUser currentUser].username);
    
}

@end
