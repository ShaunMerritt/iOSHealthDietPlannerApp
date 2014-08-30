//
//  SMFirstTimePateientViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/20/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMFirstTimePateientViewController.h"

@interface SMFirstTimePateientViewController ()

@end

@implementation SMFirstTimePateientViewController {
    NSArray *returnedFoods;
    NSArray *returnedRecipe;
    NSDictionary *dict;
    NSDictionary *dicts;
    NSDictionary *itemsReturned;
    NSDictionary *infoFromUPCScanReturned;
    NSString *doctorChosenDietURL;
}

/*
    // Use this to get email of doctor
     PFUser *user                    = [self.allDoctors objectAtIndex:indexPath.row];
     cell.textLabel.text             = user.username;
 
    // Use this to create the relation
     PFRelation *doctorsRelations = [self.currentUser relationforKey:@"doctorsRelation"];
     PFUser *user                 = [self.allDoctors objectAtIndex:indexPath.row];
     [doctorsRelations addObject:user];
     [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (error){
     NSLog(@"Error %@, %@", error, [error userInfo]);
     }
     }];
     
     // Use this to move to next view:
     UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"firstTimePatientSignedIn"];
     vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:vcs animated:YES completion:nil];
 
*/

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
    self.numberForUpdate = 0;
    self.growingIntro = [[NSMutableString alloc] initWithString:@"Welcome to Elu+\n"];
    
    self.label = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 100, self.view.frame.size.width - 80, 300)];
    
    [self.view addSubview:self.label];
    self.label.numberOfLines = 6;
    
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.label setFont:[UIFont boldSystemFontOfSize:22]];
    self.label.textColor = [UIColor colorWithRed:0.3059 green:0.8039 blue:0.7686 alpha:1.0];
    self.label.text = self.growingIntro;
    
    
    self.fadeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(bortInfo) userInfo:nil repeats:YES];
    
    
    
    // FIXME: Remember to add exception if there is no logged in user.
    
    // Find total caloreis needed perday for the logged in user.
    PFQuery *queryForDiet = [PFQuery queryWithClassName:@"CaloriesPerDay"];
    [queryForDiet whereKey:@"user" equalTo:PFUser.currentUser];
    
    [queryForDiet findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object: %@", object);
                //log the objects that we got back to the NSLOG
                NSString *reccomendedDailyCalories = [object valueForKey:@"totalDailyCalories"];
                
                
                
                [[PFUser currentUser] setObject:reccomendedDailyCalories forKey:@"RecommendedCaloriesForMaintenece"];
                
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
    
    //SMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSString *doctor = [[PFUser currentUser] objectForKey:@"isDoctor"];
        
        if ([doctor isEqualToString:@"no"]) {
            NSLog(@"Current User %@", currentUser.username);
            NSString *relatedDoctor = [[PFUser currentUser] objectForKey:@"doctorIdentifier"];
            
            PFQuery *query = [PFUser query];
            [query whereKey:@"objectId" equalTo:relatedDoctor];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                else {
                    self.allDoctors = objects;
                    // Do stuff with all doctors
                    NSLog(@"All doctore : %@", self.allDoctors);
                    self.doctor = [self.allDoctors objectAtIndex:0];
                    
                }
            }];
            
        }
        
        
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.currentUser = [PFUser currentUser];
    
    

}

- (void) bortInfo {
    self.numberForUpdate ++;
    NSLog(@"HERE");
    switch (self.numberForUpdate) {
        case 1:
            [self.growingIntro appendString:[NSString stringWithFormat:@"Welcome to Elu+\n %@",[PFUser currentUser].username]];
            break;
        case 2:
            [self.growingIntro replaceOccurrencesOfString:@"Welcome to Elu+\n" withString:@"" options:0 range:NSMakeRange(0, [self.growingIntro length])];
            [self.growingIntro appendString:@"\nWe are glad \nyou came!"];
            break;
        case 3:
            self.doctorsName = self.doctor.username;
            [self.growingIntro replaceOccurrencesOfString:@"\nWe are glad \nyou came!" withString:[NSString stringWithFormat:@"\nYour doctor: %@ \nrecommended you. ", self.doctor.username] options:0 range:NSMakeRange(0, [self.growingIntro length])];
            
            
            break;
        case 4:
            self.growingIntro = [NSMutableString stringWithFormat:@"%@, is %@ your doctor?",[PFUser currentUser].username, self.doctor.username];
            break;
        default:
            break;
    }
    
    self.label.text = self.growingIntro;

    
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

- (IBAction)yesButton:(id)sender {
    
    PFRelation *doctorsRelations = [self.currentUser relationforKey:@"doctorsRelation"];
    PFUser *user                 = [self.allDoctors objectAtIndex:0];
    [doctorsRelations addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            NSLog(@"Error %@, %@", error, [error userInfo]);
            
            
            
        }
    }];
    
    [self.fadeTimer invalidate];
    self.fadeTimer = nil;
    
    UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"firstTimePatientSignedIn"];
    vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vcs animated:YES completion:nil];
    NSLog(@"Hello");
    
}
@end
