//
//  SMFourthEditScreenForPatientViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/19/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMFourthEditScreenForPatientViewController.h"

@interface SMFourthEditScreenForPatientViewController ()

@end

@implementation SMFourthEditScreenForPatientViewController {
    NSNumber *cholesterolValue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextStepTapped:(id)sender {
    
    
    SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Find total caloreis needed perday for the logged in user.
    
    
    
    // Query for users with the same username as the one passed in from the tablecell
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:appDelegate.userName]; // the editing patient by username
    NSArray *currentPatient = [query findObjects];
    NSLog(@"Current patient is: %@", currentPatient);
    
    PFQuery *queryForDiet = [PFQuery queryWithClassName:@"CaloriesPerDay"];
    [queryForDiet whereKey:@"user" equalTo:[currentPatient objectAtIndex:0]];
    
    [queryForDiet findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object: %@", object);
                //log the objects that we got back to the NSLOG
                
                
                NSLog(@"Got to here");
            
                
                object[@"cholesterol"] = [NSString stringWithFormat:@"%@", self.cholesterolTextField.text];
                object[@"sodium"] = [NSString stringWithFormat:@"%@", self.sodiumTextField.text];
                object[@"potassium"] = [NSString stringWithFormat:@"%@", self.potassiumTextField.text];
                object[@"fiber"] = [NSString stringWithFormat:@"%@", self.fiberTextField.text];
                object[@"sugar"] = [NSString stringWithFormat:@"%@", self.sugarTextField.text];
                object[@"vitaminA"] = [NSString stringWithFormat:@"%@", self.vitaminATextField.text];
                object[@"vitaminC"] = [NSString stringWithFormat:@"%@", self.vitaminCTextField.text];
                object[@"calcium"] = [NSString stringWithFormat:@"%@", self.calciumTextField.text];
                object[@"iron"] = [NSString stringWithFormat:@"%@", self.ironTextField.text];

                
                
                [object saveInBackground];
                
                
                
                //Save all data to Parse
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        //[self dismissModalViewControllerAnimated:YES];
                    }
                }];
                
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    [self.stepsController showNextStep];
    
}


- (IBAction)previousStepTapped:(id)sender {
    [self.stepsController showPreviousStep];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Make keyboard go away when touch background
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.cholesterolTextField isFirstResponder] && [touch view] != self.cholesterolTextField) {
        [self.cholesterolTextField resignFirstResponder];
    }
    if ([self.sodiumTextField isFirstResponder] && [touch view] != self.sodiumTextField) {
        [self.sodiumTextField resignFirstResponder];
    }
    if ([self.potassiumTextField isFirstResponder] && [touch view] != self.potassiumTextField) {
        [self.potassiumTextField resignFirstResponder];
    }
    if ([self.fiberTextField isFirstResponder] && [touch view] != self.fiberTextField) {
        [self.fiberTextField resignFirstResponder];
    }
    if ([self.sugarTextField isFirstResponder] && [touch view] != self.sugarTextField) {
        [self.sugarTextField resignFirstResponder];
    }
    if ([self.vitaminCTextField isFirstResponder] && [touch view] != self.vitaminCTextField) {
        [self.vitaminCTextField resignFirstResponder];
    }
    if ([self.vitaminATextField isFirstResponder] && [touch view] != self.vitaminATextField) {
        [self.vitaminATextField resignFirstResponder];
    }
    if ([self.calciumTextField isFirstResponder] && [touch view] != self.calciumTextField) {
        [self.calciumTextField resignFirstResponder];
    }
    if ([self.ironTextField isFirstResponder] && [touch view] != self.ironTextField) {
        [self.fiberTextField resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
