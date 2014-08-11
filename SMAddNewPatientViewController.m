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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (IBAction)createPatientButton:(id)sender {
    
    [self genRandStringLength:5];
    NSLog(@"%@", uniqueCode);
    
    

    [self createNewPatient];
}

// Generates alpha-numeric-random string
- (NSString *)genRandStringLength:(int)len {
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
    //self.currentDoctorPassword = self.uniqueCode;
    
    PFUser *currentDoctor = [PFUser currentUser];
    
    NSLog(@"%@", uniqueCode);

    
    // Create new patient details and save them to the user
    PFUser *newPatient  = [PFUser user];
    newPatient.username = self.patientsEmailTextField.text;
    newPatient.email    = self.patientsEmailTextField.text;
    newPatient.password = [self genRandStringLength:5];
    
    NSLog(@"%@", newPatient.password);
    
    self.patientsPhoneNumber = self.patientsPhoneNumberTextField.text;
    
    //NSMutableString *string1 = [NSMutableString stringWithString: @"The quick brown fox jumped"];
    
    NSMutableString *patientsNumber = [NSMutableString stringWithString:self.patientsPhoneNumber];
    
    //[patientsNumber deleteCharactersInRange: [patientsNumber rangeOfString: @"+1"]];
    
    NSLog(@"%@", patientsNumber);
    
    NSLog(@"%@", [PFUser currentUser].username);
    
    
    
    
    [PFCloud callFunctionInBackground:@"inviteUser"
                       withParameters: @{@"email": newPatient.email, @"password": newPatient.password, @"doctorCode": newPatient.password, @"phoneNumberForPatient": self.patientsPhoneNumberTextField.text, @"doctorUserName": [PFUser currentUser].username, @"doctorIdentifier": [PFUser currentUser].objectId}
                                block:^(NSString *object, NSError *error) {
                                    if (!error) {
                                        NSLog(@"%@",object);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                        self.uniqueCodeLabel.text = newPatient.password;

                                    }
                                    else {
                                        NSLog(@"%@, %@", error,[error userInfo]);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                    }
                                }];

    
    // Signup the new Patient
    /*
    [newPatient signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            // In case of error show alert view
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alertView show];
        }
        else {
            NSLog(@"%@", [PFUser currentUser].username);
            // Log out Patient
            [PFUser logOut];

            NSLog(@"%@", self.currentDoctorPassword);

            // Log in the doctor with saved info
            [PFUser logInWithUsernameInBackground:[PFUser currentUser].username password:currentDoctor.password block:^(PFUser *user, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    
                    [alertView show];
                    NSLog(@"%@", self.currentDoctorPassword);
                }
                else {
                    NSLog(@"%@", [PFUser currentUser].username);
                }
            }];
        }
    }];
     */
    
    NSLog(@"%@", [PFUser currentUser].username);

    
}



@end














