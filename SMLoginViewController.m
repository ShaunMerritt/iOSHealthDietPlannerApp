//
//  SMLoginViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SMSignupViewController.h"

@interface SMLoginViewController ()

@end

@implementation SMLoginViewController
@synthesize signUpViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)login:(id)sender {
    
    // Set email and password = to textfield text
    self.email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Creat user object and set email and pass = to what we made above
    PFUser * users = [PFUser user];
    users.email = self.email;
    users.password = self.password;
    
    // Show alert view if blank
    if ([self.email length] == 0 || [self.password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Make sure you enter email, and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        // Log in user with details
        [PFUser logInWithUsernameInBackground:users.email password:users.password block:^(PFUser *user, NSError *error) {
            
            NSLog(@"%@", [PFUser currentUser].username);
            NSLog(@"%@", [PFUser currentUser].objectId);
            
            // If there is an error
            if (!user) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                
                // TODO: Change this to a query. Thats why doctor login is not working properly
                NSString *isDoctor = [[PFUser currentUser] objectForKey:@"isDoctor"];
                NSLog(@"%@", isDoctor);

                // If user is doctor take them to different part in app
                if ([isDoctor isEqualToString:@"yes"]) {
                    
                    NSLog(@"%@ is the users object id login", [PFUser currentUser].objectId);
                    
                    self.currentUserAfterLogin = user;
                    
                    NSString* myNewString = @"yes";
                    [[PFUser currentUser] setObject:myNewString forKey:@"isDoctor"];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"doctorSignedIn"];
                    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                    [self presentViewController:vc animated:YES completion:NULL];
                    
                }
                else {
                    
                    // Error
                    NSLog(@"%@", error);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
            }
        }];
    }
}
@end







