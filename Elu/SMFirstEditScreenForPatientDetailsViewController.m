//
//  SMFirstEditScreenForPatientDetailsViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMFirstEditScreenForPatientDetailsViewController.h"
#import "RMStepsController.h"
#import "ASValueTrackingSlider.h"
#import "SMAppDelegate.h"


@interface SMFirstEditScreenForPatientDetailsViewController () <ASValueTrackingSliderDataSource> {
    NSString *patientsWeight;
    NSString *patientsActivityLevel;
    //NSString *userName;
}

@property (nonatomic, strong) IBOutlet ASValueTrackingSlider *slider1;

@end

@implementation SMFirstEditScreenForPatientDetailsViewController
@synthesize isMale;
@synthesize userName = _userName;
@synthesize patientsWeightLabel, patientsWeightTextField, heightLabel, heightInFeetTextField, heightInInchesTextField, maleLabel, maleSwitch, patientsAgeTextField;

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];
    _userName = appDelegate.userName;
    
    // Set default value for isMale Bool
    isMale = YES;
    
    // Customize the slider
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"°C"];
    [tempFormatter setNegativeSuffix:@"°C"];
    
    self.slider1.dataSource = self;
    [self.slider1 setNumberFormatter:tempFormatter];
    self.slider1.minimumValue = 1.4;
    self.slider1.maximumValue = 2.4;
    self.slider1.popUpViewCornerRadius = 16.0;
    
    self.slider1.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    self.slider1.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];
    
    [self.slider1 setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
                               withPositions:@[@1.4, @1.7, @1.9, @2.1, @2.3]];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Make keyboard go away when touch background
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.patientsAgeTextField isFirstResponder] && [touch view] != self.patientsAgeTextField) {
        [self.patientsAgeTextField resignFirstResponder];
    }
    if ([self.heightInFeetTextField isFirstResponder] && [touch view] != self.heightInFeetTextField) {
        [self.heightInFeetTextField resignFirstResponder];
    }
    if ([self.heightInInchesTextField isFirstResponder] && [touch view] != self.heightInInchesTextField) {
        [self.heightInInchesTextField resignFirstResponder];
    }
    if ([self.patientsWeightTextField isFirstResponder] && [touch view] != self.patientsWeightTextField) {
        [self.patientsWeightTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
    
}

- (void)setDetailItemForPatient:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

#pragma mark - ASValueTrackingSliderDataSource
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = value;
    NSString *s;
    
    if (value <= 1.6) {
        s = @"Your patient is fat.";
    } else if (value > 1.6 && value < 2.0) {
        s = @"Your patient is lazy";
    } else if (value >= 2.0) {
        s = @"Your patient is active";
    }
    return s;
}


#pragma mark - Actions
- (IBAction)nextStepTapped:(id)sender {

    // Create patientsweight and activity level based on what doctor inputs
    patientsWeight = self.patientsWeightTextField.text;
    patientsActivityLevel = [[NSNumber numberWithFloat:self.slider1.value] stringValue];
    
    // Based on slider value change the patients sex
    NSString *patientsSex = [[NSString alloc] init];
    if (isMale == YES) {
        patientsSex = @"male";
    } else {
        patientsSex = @"female";
    }
    
    // Set patients age
    NSString *patientsAge = patientsAgeTextField.text;
    
    // Set height in inches and feet
    NSString *patientsHeightInFeet = heightInFeetTextField.text;
    NSString *patientsHeighInInches = heightInInchesTextField.text;
    
    // Call method to initiate cloud code
    [self getSuggestedDailyCaloriesForMaintence:patientsWeight activityLevel:patientsActivityLevel sex:patientsSex age:patientsAge heightInFeet:patientsHeightInFeet heightInches:patientsHeighInInches];
    
}

- (IBAction)previousStepTapped:(id)sender {
    [self.stepsController showPreviousStep];
}

- (IBAction)switchValueChanged:(id)sender {
    
    // Change isMale based on the value of the uiswitch. Here is the if else statement
    if ([self.maleSwitch isOn]) {
        isMale = YES;
    } else {
        isMale = NO;
    }
    
}

#pragma mark - HelperMethods
- (void) getSuggestedDailyCaloriesForMaintence: (NSString *)weight activityLevel:(NSString *)activity sex:(NSString *)patientsSex age:(NSString *)patientsAge heightInFeet: (NSString *)patientsHeightInFeet heightInches: (NSString *)patientsHeightInInches{
    
    /*  Call cloud code function "generateRecommendedCaloriesForMen", and pass in parameters that are included in method call. This should return the total calories a patient should have a day to maintain weight */
    [PFCloud callFunctionInBackground:@"generateRecommendedCaloriesForMen"
                       withParameters: @{@"weight": weight, @"activityNumber": activity, @"sex": patientsSex, @"age": patientsAge, @"heightInFeet": patientsHeightInFeet, @"heightInches": patientsHeightInInches}
                                block:^(NSString *object, NSError *error) {
                                    // If there is no error
                                    if (!error) {
                                        
                                        NSLog(@"Here is the object: %@",object);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                        
                                        // Save the total calories in the app delegate for the next step
                                        SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];
                                        appDelegate.totalCaloriesForMaintenece = [object intValue];
                                        
                                        // Query for users with the same username as the one passed in from the tablecell
                                        PFQuery *query = [PFUser query];
                                        [query whereKey:@"username" equalTo:_userName]; // the editing patient by username
                                        NSArray *currentPatient = [query findObjects];
                                        NSLog(@"Current patient is: %@", currentPatient);
                                        
                                        
                                        
                                        
                                        
                                        PFQuery *queryForUser = [PFQuery queryWithClassName:@"CaloriesPerDay"];
                                        [queryForUser whereKey:@"user" equalTo:[currentPatient objectAtIndex:0]];
                                        [queryForUser countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                                            if (!error) {
                                                if (count < 1) {
                                                    
                                                    NSLog(@"Im here still");
                                                    // Create PFACL object with the current user (doctor)
                                                    PFACL *acl = [PFACL ACLWithUser:PFUser.currentUser];
                                                    
                                                    // userList is an NSArray with the users we are sending this message to.
                                                    // For each user in userList add them to the PFACL and also add all of the info needed
                                                    for (PFUser *user in currentPatient) {
                                                        [acl setReadAccess:YES forUser:user];
                                                        PFObject *calories = [PFObject objectWithClassName:@"CaloriesPerDay"];
                                                        calories[@"totalDailyCalories"] = object;
                                                        calories.ACL = acl;
                                                        calories[@"user"] = user;
                                                        [calories saveInBackground];
                                                    }

                                                } else {
                                                    PFQuery *query = [PFQuery queryWithClassName:@"CaloriesPerDay"];
                                                    //[query whereKey:@"user" equalTo:[currentPatient objectAtIndex:0]];
                                                    [query includeKey:[currentPatient objectAtIndex:0]];
                                                    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
                                                        
                                                        // Now let's update it with some new data. In this case, only cheatMode and score
                                                        // will get sent to the cloud. playerName hasn't changed.
                                                        userStats[@"totalDailyCalories"] = object;
                                                        [userStats saveInBackground];
                                                        
                                                    }];

                                                }
                                            } else {
                                                // The request failed
                                            }
                                            
                                        }];
                                        
                                        
                                        
                                        
                                        // Call the next step method for the steps GitHub project
                                        [self.stepsController showNextStep];
                                        NSLog(@"%@", [PFUser currentUser].username);

                                    }
                                    else {
                                        
                                        // If there is an error
                                        NSLog(@"%@, %@", error,[error userInfo]);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                        
                                    }
                                }];
}

@end
