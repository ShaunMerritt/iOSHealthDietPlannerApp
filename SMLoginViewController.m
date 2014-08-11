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
    self.appDelegate                    = [[UIApplication sharedApplication] delegate];
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)login:(id)sender {
    
    self.email    = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    PFUser * users = [PFUser user];
    users.email    = self.email;
    users.password = self.password;
    
    if ([self.email length] == 0 || [self.password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Make sure you enter email, and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        [PFUser logInWithUsernameInBackground:users.email password:users.password block:^(PFUser *user, NSError *error) {
            NSLog(@"HERE");
            NSLog(@"%@", [PFUser currentUser].username);
            NSLog(@"%@", [PFUser currentUser].objectId);
            if (!user) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            else {
                
                NSString *isDoctor = [[PFUser currentUser] objectForKey:@"isDoctor"];
                NSLog(@"%@", isDoctor);

                if ([isDoctor isEqualToString:@"yes"]) {
                    NSLog(@"%@ is the users object id login", [PFUser currentUser].objectId);
                    
                    self.currentUserAfterLogin = user;
                    
                    NSString* myNewString = @"yes";
                    [[PFUser currentUser] setObject:myNewString forKey:@"isDoctor"];
                    UIStoryboard *sb        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    UIViewController *vc    = [sb instantiateViewControllerWithIdentifier:@"doctorSignedIn"];
                    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                    [self presentViewController:vc animated:YES completion:NULL];
                }
                else {
                    NSLog(@"%@", error);
                    
                    
                    //Uncomment next line
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    

                }
                
            }
        }];
    }
}
@end







