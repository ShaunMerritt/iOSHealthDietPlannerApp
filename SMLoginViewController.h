//
//  SMLoginViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSignupViewController.h"

@interface SMLoginViewController : UIViewController

@property (weak, nonatomic  ) IBOutlet UITextField   *emailField;
@property (weak, nonatomic  ) IBOutlet UITextField   *passwordField;
@property (strong, nonatomic) SMSignupViewController *signUpViewController;
@property (nonatomic, strong) SMAppDelegate          *appDelegate;
@property (nonatomic, strong) PFUser                 *currentUserAfterLogin;
@property (nonatomic, strong) NSString               *email;
@property (nonatomic, strong) NSString               *password;

- (IBAction)login:(id)sender;


@end
