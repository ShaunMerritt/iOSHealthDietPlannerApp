//
//  SMEditPatientDietViewController.m
//  Elu
//
//  Created by Shaun Merritt on 7/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMEditPatientDietViewController.h"
#import "SMFirstEditScreenForPatientDetailsViewController.h"
#import "SMAppDelegate.h"

@interface SMEditPatientDietViewController () {
    NSString *patientsWeight;
    NSString *patientsActivityLevel;
    BOOL isMale;
    NSString *userUsername;
}
- (void)configureView;
@end

@implementation SMEditPatientDietViewController
@synthesize thePickerView;
@synthesize oneColumnList;
@synthesize secondColumnList;
@synthesize capsAndRegs;
@synthesize currentFirstColumn;
@synthesize currentSecondColumn;


#pragma mark - Lifecycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
    
    isMale = YES;
    
    //Two Column Array Setup
    self.oneColumnList = [[NSArray alloc] initWithObjects:@"Cholestrol", @"Fats", @"Shakeds", @"Carbs", @"Protein", @"Grains", nil];
    
    self.secondColumnList = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    capsAndRegs = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  @"Cholestrol" : @"5",
                                                                  @"Fats" : @"2",
                                                                  @"Shakeds" : @"1.5",
                                                                  @"Carbs" : @"10",
                                                                  @"Protein" : @"5",
                                                                  @"Grains" : @"3",
                                                                  }];
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.userName = [_detailItem description];
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.patientsNameLabel.text = [self.detailItem description];
        userUsername = [self.detailItem description];
    }
    
    thePickerView.showsSelectionIndicator = TRUE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [oneColumnList count];
    }
    
    return [secondColumnList count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    //For one component (column)
    //return [oneColumnList objectAtIndex:row];
    
    //For mutiple columns
    if (component == 0) {
        return [oneColumnList objectAtIndex:row];
    }
    return [secondColumnList objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        NSLog(@"One: %@", [oneColumnList objectAtIndex:row]);
        currentFirstColumn = [oneColumnList objectAtIndex:row];
        return;
    }
    
    NSLog(@"Two: %@", [secondColumnList objectAtIndex:row]);
    currentSecondColumn = [secondColumnList objectAtIndex:row];

    
    
}

#pragma mark - IBActions
- (IBAction)saveAsCapPressed:(id)sender {
    
    if (isMale) {
        switch (self.activitySegmentedControl.selectedSegmentIndex) {
            case 0:
                patientsWeight = self.patientWeightTextField.text;
                patientsActivityLevel = @"10";
                [self getSuggestedDailyCaloriesForMaintence:patientsWeight activityLevel:patientsActivityLevel];
                break;
            case 1:
                patientsWeight = self.patientWeightTextField.text;
                patientsActivityLevel = @"12";
                [self getSuggestedDailyCaloriesForMaintence:patientsWeight activityLevel:patientsActivityLevel];
                break;
            default:
                patientsWeight = self.patientWeightTextField.text;
                patientsActivityLevel = @"14";
                [self getSuggestedDailyCaloriesForMaintence:patientsWeight activityLevel:patientsActivityLevel];
                break;
        }

    } else {
        NSLog(@"Else");

    }
    
    
    switch (self.weightSegmentedControl.selectedSegmentIndex) {
        case 0:
            //TODO;
            break;
        case 1:
            //TODO;
            break;
        default:
            //TODO;
            break;
    }

    
    [capsAndRegs setObject:currentSecondColumn forKey:currentFirstColumn];
    NSLog(@"%@", capsAndRegs);
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[self.detailItem description]]; // the editing patient by username
    NSArray *currentPatient = [query findObjects];
    NSLog(@"Current patient is: %@", currentPatient);
    

    PFACL *acl = [PFACL ACLWithUser:PFUser.currentUser];
    
    // userList is an NSArray with the users we are sending this message to.
    for (PFUser *user in currentPatient) {
        [acl setReadAccess:YES forUser:user];
        PFObject *todo = [PFObject objectWithClassName:@"DietRestrictions"];
        todo[@"caps"] = capsAndRegs;
        todo[@"user"] = user;
        todo.ACL = acl;
        [todo saveInBackground];
    }
    
    PFQuery *queryTest = [PFQuery queryWithClassName:@"DietRestrictions"];
    NSArray *log = [queryTest findObjects];
    NSLog(@"Log says: %@", log);
    
}



- (IBAction)switchValueChanged:(id)sender {
    if ([self.maleSwitch isOn]) {
        isMale = YES;
    } else {
        isMale = NO;
    }
}

#pragma mark - HelperMethods
- (void) getSuggestedDailyCaloriesForMaintence: (NSString *)weight activityLevel:(NSString *)activity {
    [PFCloud callFunctionInBackground:@"generateRecommendedCaloriesForMen"
                       withParameters: @{@"weight": weight, @"activityNumber": activity}
                                block:^(NSString *object, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Here is the object: %@",object);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                        //self.uniqueCodeLabel.text = newPatient.password;
                                        
                                        
                                        
                                        PFQuery *query = [PFUser query];
                                        [query whereKey:@"username" equalTo:[self.detailItem description]]; // the editing patient by username
                                        NSArray *currentPatient = [query findObjects];
                                        NSLog(@"Current patient is: %@", currentPatient);
                                        
                                        
                                        PFACL *acl = [PFACL ACLWithUser:PFUser.currentUser];
                                        
                                        // userList is an NSArray with the users we are sending this message to.
                                        for (PFUser *user in currentPatient) {
                                            [acl setReadAccess:YES forUser:user];
                                            PFObject *calories = [PFObject objectWithClassName:@"CaloriesPerDay"];
                                            calories[@"totalDailyCalories"] = object;
                                            calories.ACL = acl;
                                            calories[@"user"] = user;
                                            [calories saveInBackground];
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                    else {
                                        NSLog(@"%@, %@", error,[error userInfo]);
                                        NSLog(@"%@", [PFUser currentUser].username);
                                    }
                                }];
}

- (void)creatACLForPatientsDietType: (NSString *)dietURL {
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[self.detailItem description]]; // the editing patient by username
    NSArray *currentPatient = [query findObjects];
    NSLog(@"Current patient is: %@", currentPatient);
    
    
    PFACL *acl = [PFACL ACLWithUser:PFUser.currentUser];
    
    // userList is an NSArray with the users we are sending this message to.
    for (PFUser *user in currentPatient) {
        [acl setReadAccess:YES forUser:user];
        PFObject *diet = [PFObject objectWithClassName:@"MainDietName"];
        diet[@"url"] = dietURL;
        diet[@"user"] = user;
        diet.ACL = acl;
        [diet saveInBackground];
    }
    
    PFQuery *queryTest = [PFQuery queryWithClassName:@"MainDietName"];
    NSArray *log = [queryTest findObjects];
    NSLog(@"Log says: %@", log);
    
    
}



#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([[segue identifier] isEqualToString:@"pushedToEditPatient"]) {
//        
//        NSLog(@"here");
//        
////        PFUser *user = self.detailItem;
////        NSString *userName = [self.detailItem description];
//        [[segue destinationViewController] setDetailItemForPatient:userUsername];
//        
//    }
//    
//}




@end
