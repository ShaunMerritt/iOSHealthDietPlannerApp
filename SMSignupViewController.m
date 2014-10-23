//
//  SMSignupViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMSignupViewController.h"
#import "Patient.h"

@interface SMSignupViewController ()

@end

@implementation SMSignupViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
}

#pragma mark - IBActions
- (IBAction)signupButton:(id)sender {
    
    // Create email and password strings
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Set isDoctor bool based on switch. (Stored in app delegate)
    if ([self.doctorSwitch isOn]) {
        _appDelegate.isDoctor = YES;
    }
    else {
        _appDelegate.isDoctor = NO;
    }
    
    // If text field length = 0 show alert view, otherwise create new user
    if ([email length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Make sure you enter email, and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        
        // Create a new user object, and set its details
        PFUser *newUser  = [PFUser user];
        newUser.username = self.userNameTextField.text;
        newUser.password = password;
        newUser.email    = email;
        
        // Signup the user
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            // If there is error, show alert view, otherwise, log them in.
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                [alertView show];
            }
            else {
                [PFUser logInWithUsernameInBackground:[PFUser currentUser].username password:[PFUser currentUser].password
                        block:^(PFUser *user, NSError *error) {
                            if (user) {
                                // Means Login is successful
                                NSLog(@"%@", [PFUser currentUser].objectId);
                                
                                
                                NSString* myNewString = @"yes";
                                [[PFUser currentUser] setObject:myNewString forKey:@"isDoctor"];
                                [[PFUser currentUser] setObject:[PFUser currentUser].objectId forKey:@"doctorId"];
                                                        
                                                        
                                //Save all data to Parse
                                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (!error) {
                                //[self dismissModalViewControllerAnimated:YES];
                                }
                            }];

                        } else {
                            // The login failed. Check error to see why.
                                }
                            }];
                    }
        }];
        
        
        // More sequential code that runs right away!
    }
    
}




@end









