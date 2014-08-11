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
    NSLog(@"Loaded");
    
    // FIXME: Remember to add exception if there is no logged in user.
    
    
    
    
    
//    
//    
//    [PFCloud callFunctionInBackground:@"generateRecommendedCaloriesForMen"
//                       withParameters: @{@"weight": @"120", @"activityNumber": @"1.8", @"heightInCM": @"155", @"sex": @"female", @"age": @"16", @"heightInFeet": @"5", @"heightInches": @"4"}
//                                block:^(NSString *object, NSError *error) {
//                                    if (!error) {
//                                        NSLog(@"Here is the object: %@",object);
//                                        NSLog(@"%@", [PFUser currentUser].username);
//                                        //self.uniqueCodeLabel.text = newPatient.password;
//                                
//                                        
//                                    }
//                                    else {
//                                        NSLog(@"%@, %@", error,[error userInfo]);
//                                        NSLog(@"%@", [PFUser currentUser].username);
//                                    }
//                                }];
//
//    
//    
//    
//    
//    
//    
//    
//    
//    PFQuery *queryForDiet = [PFQuery queryWithClassName:@"CaloriesPerDay"];
//    [queryForDiet whereKey:@"user" equalTo:PFUser.currentUser];
//    
//    [queryForDiet findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            //The find succeeded.
//            //Do something with the found objects
//            NSLog(@"NO error");
//            NSLog(@"Objects: %@", objects);
//            for (PFObject *object in objects) {
//                NSLog(@"object: %@", object);
//                //log the objects that we got back to the NSLOG
//                NSString *reccomendedDailyCalories = [object valueForKey:@"totalDailyCalories"];
//                
//                [[PFUser currentUser] setObject:reccomendedDailyCalories forKey:@"RecommendedCaloriesForMaintenece"];
//                
//                //Save all data to Parse
//                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (!error) {
//                        //[self dismissModalViewControllerAnimated:YES];
//                    }
//                }];
//                
//                
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//    

    
    
        
    
    NSLog(@"Got here");
    
    // =============************ HERE IS WHERE YOU NEED TO UNCOMMENT ***************============
    
//    SMYummlyHTTPClient *client = [SMYummlyHTTPClient sharedSMYummlyHTTPClient];
//    client.delegate = self;
//    [client searchForRecipe: @"ice cream"];
//
//    SMNutritionixClient *nutrition = [SMNutritionixClient sharedSMNutritionixHTTPClient];
//    nutrition.delegate = self;
//    [nutrition searchForFoodItem:@"tacos"];
//
//    SMNutritionixUPCClient *upcClient = [SMNutritionixUPCClient sharedSMNutritionixUPCClient];
//    upcClient.delegate = self;
//    [upcClient searchForItemIdFromUPCScan:@"52200004265"];
    
    
    
    
//    
//    NSURL *urls = [NSURL URLWithString: doctorChosenDietURL];
//    NSMutableArray *profileArray = [[NSMutableArray alloc] initWithContentsOfURL:urls];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *pathy = [documentsDirectory stringByAppendingPathComponent:@"dietsPlistTest.plist"];
//    [profileArray writeToFile:pathy atomically:YES];
//    
//    // create nsdata from that path using
//    NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:pathy];
//    
//    //Expand into object:
//    NSError *error;
//	NSArray *diets = [NSPropertyListSerialization propertyListWithData:plistData options: NSPropertyListImmutable format: nil error:&error];
//    if (diets) {
//        
//	}
//	else {
//		NSLog(@"Error: %@", error);
//	}
//    
//	NSDictionary * diet = [diets firstObject];
//    NSString * calories = diet[@"Calories"];
//    NSString * exercise = diet[@"Exercise"];
//    
//    NSLog(@"Calories: %@", calories);
//    NSLog(@"Exercise: %@", exercise);
//
    

    
        
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
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

- (void) nutritionixUPCClient:(SMNutritionixUPCClient *)client didUpdateWithIdFromUPCScan:(id)itemId {
    infoFromUPCScanReturned = itemId;
    NSLog(@"FOOD ITEM HERE: %@", itemId);
    [self logItemsReturnedFromUPCSCAN];
}

- (void) nutritionixUPCClient:(SMNutritionixClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}

- (void) logItemsReturnedFromUPCSCAN {
    
    
    NSString* item_id = [infoFromUPCScanReturned objectForKey:@"item_id"];
    NSString* item_name = [infoFromUPCScanReturned objectForKey:@"item_name"];
    NSString* brand_name = [infoFromUPCScanReturned objectForKey:@"brand_name"];
    NSString* nf_calories = [infoFromUPCScanReturned objectForKey:@"nf_calories"];
    
    NSLog(@"Regular Index: %@", item_id);
    NSLog(@"Regular Type: %@", item_name);
    NSLog(@"Regular Score: %@", brand_name);
    NSLog(@"Regular Id: %@", nf_calories);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAY!!!" message:[NSString stringWithFormat:@"You scanned an item with the id: %@. The items name is: %@. The Brand Name is: %@. And it has %@ calories.", item_id, item_name, brand_name, nf_calories] delegate:nil cancelButtonTitle:@"Thanks" otherButtonTitles: nil];
    
    [alert show];
}


- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didUpdateWithFoodItem:(id)foodItem {
    itemsReturned = foodItem;
    NSLog(@"FOOD ITEM HERE: %@", foodItem);
    [self logItemsReturned];
}

- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}


- (void) logItemsReturned {
    
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [itemsReturned objectForKey:@"hits"];
    
    NSArray* listOfMatchingFoods = [itemsReturned objectForKey:@"hits"]; //2
    
    
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:0];
    
    NSLog(@"BEST FOOD MATCH: %@", bestFoodMatch);
    
    NSString* index = [bestFoodMatch objectForKey:@"_index"];
    NSString* type = [bestFoodMatch objectForKey:@"_type"];
    NSString* score = [bestFoodMatch objectForKey:@"_score"];
    NSString* id = [bestFoodMatch objectForKey:@"_id"];
    
    NSLog(@"Regular Index: %@", index);
    NSLog(@"Regular Type: %@", type);
    NSLog(@"Regular Score: %@", score);
    NSLog(@"Regular Id: %@", id);

    
    NSDictionary* fields = [bestFoodMatch objectForKey:@"fields"];
    NSString* item_name = [fields objectForKey:@"item_name"];
    NSString* brand_name = [fields objectForKey:@"brand_name"];
    NSString* nf_serving_size_qty = [fields objectForKey:@"nf_serving_size_qty"];

    NSLog(@"Fields fields: %@", fields);
    NSLog(@"Fields item_name: %@", item_name);
    NSLog(@"Fields brand_name: %@", brand_name);
    NSLog(@"Fields nf_servine: %@", nf_serving_size_qty);



    
}



- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didUpdateWithFood:(id)food {
    
    
    NSLog(@"TETETETETE");
    //NSLog(@"%@", food);
    dicts = food;
    [self log];

    
    //[self didReceiveJSON: food];

    
}

- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    NSLog(@"%@", error);
    
    [alert show];
}

- (void) didReceiveJSON: (NSDictionary*)obj {
    NSArray *matches = obj[@"matches"];
    NSLog(@"MAthces : %@", matches);
    
    @try {
        returnedFoods = [YummlyModel arrayOfModelsFromDictionaries:matches];
        NSLog(@"RETURNES: %@", returnedFoods);
    }
    @catch (NSException *exception) {
        NSLog(@"AFNETWORK ERROR");
    }
    
    [self log];
    
    

    
}

- (void) logRecipe {
    
    NSLog(@"ingredientLines: %@", [dict objectForKey:@"ingredientLines"]);
    NSLog(@"flavors: %@", [dict objectForKey:@"flavors"]);
    NSLog(@"nutritionEstimates: %@", [dict objectForKey:@"nutritionEstimates"]);
    NSLog(@"numberOfServings: %@", [dict objectForKey:@"numberOfServings"]);
    
}

- (void) log {
    /*
    YummlyModel* foods = returnedFoods[0];
    NSLog(@"Retuenr: %@",foods);
    NSLog(@"%@", foods.id);
    NSLog(@"%@", foods.ingredients);
    NSLog(@"%@", foods.recipeName);
    NSLog(@"%@", foods.totalTimeInSeconds);
    NSLog(@"%@", foods.sourceDisplayName);
    NSLog(@"%i", foods.rating);
    
    NSLog(@"HERE");
     */
    
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [dicts objectForKey:@"matches"];
    
    NSArray* listOfMatchingFoods = [dicts objectForKey:@"matches"]; //2
    
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:0];
    
    NSString* recipeName = [bestFoodMatch objectForKey:@"recipeName"];
    NSString* ingredients = [bestFoodMatch objectForKey:@"ingredients"];
    NSString* totalTimeInSeconds = [bestFoodMatch objectForKey:@"totalTimeInSeconds"];
    NSString* id = [bestFoodMatch objectForKey:@"id"];
    
    NSLog(@"NAME: %@", recipeName);
    NSLog(@"Ingr: %@", ingredients);
    NSLog(@"total: %@", totalTimeInSeconds);
    NSLog(@"id: %@", id);

    
   
    
    SMYummlyGetClient *getClient = [SMYummlyGetClient sharedSMYummlyGetHTTPClient];
    getClient.delegate = self;
    [getClient findRecipeWithId:id];
    
    
}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didUpdateWithRecipe:(id)recipe {
    dict = recipe;
    [self logRecipe];

}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
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
    PFUser *currentUser = [PFUser currentUser];
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
    
    [self presentModalViewController: reader
                            animated: YES];
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
        
        [reader dismissModalViewControllerAnimated: YES];
        
    }
    
    
}
@end







