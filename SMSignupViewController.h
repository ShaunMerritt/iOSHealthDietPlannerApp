//
//  SMSignupViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSignupViewController : UIViewController

@property (weak, nonatomic  ) IBOutlet UITextField   *emailField;
@property (weak, nonatomic  ) IBOutlet UITextField   *passwordField;
@property (weak, nonatomic  ) IBOutlet UITextField   *userNameTextField;
@property (weak, nonatomic  ) IBOutlet UISwitch      *doctorSwitch;
@property (nonatomic, strong) SMAppDelegate          *appDelegate;

- (IBAction)signupButton:(id)sender;

@end
