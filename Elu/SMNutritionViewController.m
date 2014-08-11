//
//  SMNutritionViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMNutritionViewController.h"
#import "YummlyModel.h"
#import "YummlyGetModel.h"
#import "SMNutritionixClient.h"

@interface SMNutritionViewController ()

@end

@implementation SMNutritionViewController {
    NSArray *returnedFoods;
    NSArray *returnedRecipe;
    NSDictionary *dict;
    NSDictionary *dicts;
    NSDictionary *itemsReturned;
    NSDictionary *infoFromUPCScanReturned;
    NSString *doctorChosenDietURL;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                    [self.tableView reloadData];
                }
            }];

        }
        
        
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    self.currentUser = [PFUser currentUser];

    

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allDoctors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellNow";
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFUser *user                    = [self.allDoctors objectAtIndex:indexPath.row];
    cell.textLabel.text             = user.username;
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell        = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType           = UITableViewCellAccessoryCheckmark;

    PFRelation *doctorsRelations = [self.currentUser relationforKey:@"doctorsRelation"];
    PFUser *user                 = [self.allDoctors objectAtIndex:indexPath.row];
    [doctorsRelations addObject:user];
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error){
            NSLog(@"Error %@, %@", error, [error userInfo]);
        }
    }];
    
    /*
    UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"foodLikedViewController"];
    vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vcs animated:YES completion:nil];
    */
     
    
    UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"firstTimePatientSignedIn"];
    vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vcs animated:YES completion:nil];
    
    
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    //PFUser *currentUser = [PFUser currentUser];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)scanItemButtonPressed:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;

    [self presentViewController:reader animated:YES completion:nil];
//    [self presentModalViewController: reader
//                            animated: YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    NSLog(@"%@", results);
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results){
        
        NSString *upcString = symbol.data;
        
        SMNutritionixUPCClient *upcClient = [SMNutritionixUPCClient sharedSMNutritionixUPCClient];
        upcClient.delegate = self;
        [upcClient searchForItemIdFromUPCScan:upcString];
        
        [reader dismissViewControllerAnimated:YES completion:nil];
        //[reader dismissModalViewControllerAnimated: YES];

    }
    
    
}
@end







