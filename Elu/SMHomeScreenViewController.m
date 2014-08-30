//
//  SMHomeScreenViewController.m
//  Elu
//
//  Created by Shaun Merritt on 7/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMHomeScreenViewController.h"
#import "SMConstants.h"

@interface SMHomeScreenViewController () {
    NSMutableDictionary *dicts;
    NSMutableDictionary *dict;
    SMYummlyHTTPClient *client;
}

@end

@implementation SMHomeScreenViewController
@synthesize restrictionsLabel;

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
    
//    self.plistPath = [[NSBundle mainBundle] pathForResource:@"WeeklyDietPropertyList" ofType:@"plist"];
//    self.plistData = [[NSFileManager defaultManager] contentsAtPath:self.plistPath];
//    
//    NSError *error;
//    NSArray *meals = [NSPropertyListSerialization propertyListWithData:_plistData options:NSPropertyListImmutable format:nil error:&error];
//    
//    if (meals) {
//        
//        NSArray *meal = [meals firstObject];
//        NSDictionary *mealDetails = [meal firstObject];
//        NSString *mealName = mealDetails[@"Recipe Name"];
//        NSLog(@"Here is the name of the meal: %@", mealName);
//        
//        NSMutableArray *secondMeal = [[NSMutableArray alloc] init];
//        
//        NSMutableDictionary *mealOne = [[NSMutableDictionary alloc] init];
//        mealOne[@"Recipe Name"] = @"Name";
//        mealOne[@"Recipe Id"] = @(123);
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"]; NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        if (![fileManager fileExistsAtPath: path])
//        {
//            path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"plist.plist"] ];
//        }
//        
//    }


    
    // Query for objects in class DietRestrictions with the same username as the current user
    PFQuery *query = [PFQuery queryWithClassName:@"CaloriesPerDay"];
    [query whereKey:@"user" equalTo:PFUser.currentUser];
    
    NSLog(@"I got th here");
    
    self.mealString = [[NSString alloc] init];
    
    // Find the objects from the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // No error
                    NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);
                    // For each of the objects that is returned
                    client = [SMYummlyHTTPClient sharedSMYummlyHTTPClient];
                    client.delegate = self;

                        NSLog(@"I is: %d", self.i);
                        for (PFObject *object in objects) {
                            //log the objects that we got back to the NSLOG
                            self.allergiesArray = [object valueForKey:@"arrayOfAllergies"];
                            self.caloriesForFats = [[object valueForKey:@"caloriesDedicatedToFats"] intValue]/3/3;
                            self.caloriesForProteins = [[object valueForKey:@"caloriesDedicatedToProteins"] intValue]/3;
                            self.caloriesForCarbs = [[object valueForKey:@"caloriesDedicatedToCarbs"] intValue]/3/5;
                            self.caloriesForDay = [[object valueForKey:@"totalDailyCalories"] intValue]/3;
                            self.calcium = [[object valueForKey:@"calcium"] intValue]/3;
                            self.cholesterol = [[object valueForKey:@"cholesterol"] intValue]/3;
                            self.fiber = [[object valueForKey:@"fiber"] intValue]/3;
                            self.iron = [[object valueForKey:@"iron"] intValue]/3;
                            self.potassium = [[object valueForKey:@"potassium"] intValue]/3/100;
                            self.sodium = [[object valueForKey:@"sodium"] intValue]/3/100;
                            self.sugar = [[object valueForKey:@"sugar"] intValue]/3;
                            self.vitaminA = [[object valueForKey:@"vitaminA"] intValue]/3;
                            self.vitaminC = [[object valueForKey:@"vitaminC"] intValue]/3;
                            
                            [self pupJesusIsBorn];
                            
                    
                        
                    }
                }
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
        
          }];
    
    

}

- (void) pupJesusIsBorn {
    
    NSLog(@"Pup");
    
    self.caloriesDedicatedToBreakfast = self.caloriesForDay * 0.25;
    self.caloriesDedicatedToLunch = self.caloriesForDay * 0.4;
    self.caloriesDedicatedToSnackBetweenLunchAndDinner = self.caloriesForDay * 0.1;
    self.caloriesDedicatedToDinner = self.caloriesForDay * 0.25;
    
    NSLog(@"Value for fats here %d", self.caloriesForFats);
    
    
        
        switch (self.i) {
            case 0:
                self.mealString = kSMBreakfast;
                break;
            case 1:
                self.mealString = kSMLunchAndSnacks;
                break;
            default:
                self.mealString = kSMMainDishes;
                break;
        }

        NSLog(@"Meal str: %@", self.mealString);
    
        [client searchForRecipe:@"" meal:self.mealString allergies:self.allergiesArray valueForCarbs:self.caloriesForCarbs valueForFats:self.caloriesForFats valueForProteins:self.caloriesForProteins valueForCalcium:self.calcium valueForCholesterol:self.cholesterol valueForFiber:self.fiber valueForIron:self.iron valueForPotassium:self.potassium valueForSodium:self.sodium valueForSugar:self.sugar valueForVitaminA:self.vitaminA valueForVitaminC:self.vitaminC];
    
    self.i++;
    
}

- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didUpdateWithFood:(id)food {
    //NSLog(@"HERE");
    dicts = food;
    [self log];
}

- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil 			cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

- (void) log {
    
    // Create the dictionary and set the key mapping structure
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [dicts objectForKey:@"matches"];
    
    //NSLog(@"test %@", test);
    
    NSArray* listOfMatchingFoods = [dicts objectForKey:@"matches"]; //2
    
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:self.i];
    
    NSString* recipeName = [bestFoodMatch objectForKey:@"recipeName"];
    NSString* ingredients = [bestFoodMatch objectForKey:@"ingredients"];
    NSString* totalTimeInSeconds = [bestFoodMatch objectForKey:@"totalTimeInSeconds"];
    NSString* id = [bestFoodMatch objectForKey:@"id"];
    
    NSLog(@"Recipe Name: %@", recipeName);
    NSLog(@"Recipe Ingr: %@", ingredients);
    NSLog(@"Recipe total time in sec: %@", totalTimeInSeconds);
    NSLog(@"Recipe id: %@", id);
    
    // Create the get client to return the recipe (This just returns the first food from the search)
    SMYummlyGetClient *getClient = [SMYummlyGetClient sharedSMYummlyGetHTTPClient];
    getClient.delegate = self;
    [getClient findRecipeWithId:id];
}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didUpdateWithRecipe:(id)recipe {
    dict = recipe;
    [self logRecipe];
}

- (void) logRecipe {
    
    NSLog(@"ingredientLines: %@", [dict objectForKey:@"ingredientLines"]);
    NSLog(@"flavors: %@", [dict objectForKey:@"flavors"]);
    //NSLog(@"nutritionEstimates: %@", [dict objectForKey:@"nutritionEstimates"]);
    NSLog(@"numberOfServings: %@", [dict objectForKey:@"numberOfServings"]);
    NSLog(@"yield: %@", [dict objectForKey:@"yield"]);
    NSLog(@"name: %@", [dict objectForKey:@"name"]);
    
    NSArray *listOfMatchingCuisines = [dicts objectForKey:@"attribute"];
    NSArray *bestFoodMatch = [listOfMatchingCuisines objectAtIndex:1];
    NSLog(@"Best Meal Match = %@", bestFoodMatch);

    [self pupJesusIsBorn];
    
    
}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString 						stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
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

@end
