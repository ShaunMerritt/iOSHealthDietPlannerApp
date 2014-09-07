//
//  SMThirdEditScreenForPatientDetailsViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/18/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMThirdEditScreenForPatientDetailsViewController.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "SMAppDelegate.h"
#import "SMSecondEditPatientTableViewController.h"
#import "SMFirstEditScreenForPatientDetailsViewController.h"
#import "SMAppDelegate.h"


@interface SMThirdEditScreenForPatientDetailsViewController ()

@end

@implementation SMThirdEditScreenForPatientDetailsViewController

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
    
    // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    self.allAllergies = [[NSMutableArray alloc] init];
    
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.dictionary = [[NSDictionary alloc] init];
    
    self.emailTextField.autocompleteType = HTAutocompleteTypeColor;
    
    

    
    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    // Add one tag
    
    // Tag main color
    [[AMTagView appearance] setTagColor:[UIColor colorWithRed:0.3333 green:0.3843 blue:0.4392 alpha:1.0]];
    
    // Tag label background color
    [[AMTagView appearance] setInnerTagColor:[UIColor colorWithRed:0.3059 green:0.8039 blue:0.7686 alpha:1.0]];
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.emailTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)addButtonTapped:(id)sender {
    
    
    [self.emailTextField resignFirstResponder];
    [self.tagListView addTag:self.emailTextField.text];
    NSLog(@"%@", [HTAutocompleteManager sharedManager].arrayForKeys);
    
    NSArray *keys = @[@"392^Wheat-Free",
                      @"393^Gluten-Free",
                      @"394^Peanut-Free",
                      @"395^Tree Nut-Free",
                      @"396^Dairy-Free",
                      @"397^Egg-Free",
                      @"398^Seafood-Free",
                      @"399^Sesame-Free",
                      @"400^Soy-Free",
                      @"401^Sulfite-Free"
        ];
    self.dictionary = [NSDictionary dictionaryWithObjects:keys
                                                  forKeys:[HTAutocompleteManager sharedManager].arrayForKeys];
    
    NSLog(@"dic: %@", self.dictionary);
    
    NSString *allergySelected = [self.emailTextField.text lowercaseString];
    
    NSLog(@"al %@", allergySelected);
    
    NSString *newAllergy = [self.dictionary objectForKey:allergySelected];
    
    NSLog(@"new %@", newAllergy);
    
    
    if (newAllergy) {
        [self.allAllergies addObject:newAllergy];
        NSLog(@"aller %@", self.allAllergies);
    }
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
                object[@"arrayOfAllergies"] = self.allAllergies;
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



@end
