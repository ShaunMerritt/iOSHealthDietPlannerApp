//
//  SMHomeScreenViewController.m
//  Elu
//
//  Created by Shaun Merritt on 7/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMHomeScreenViewController.h"
#import "SMConstants.h"
#import "SMAppDelegate.h"

@interface SMHomeScreenViewController () {
    NSMutableDictionary *dicts;
    NSMutableDictionary *dict;
    SMYummlyHTTPClient *client;
    NSDate *currentDate;
    NSCalendar *calendar;
    NSDateComponents *components;
    int numberOfTimesPlistSaved;
}

@end

@implementation SMHomeScreenViewController
@synthesize restrictionsLabel;
@synthesize allMeals;
@synthesize currentMeal;
@synthesize mealNumber;
@synthesize returnedRecipeID;
@synthesize returnedRecipeName;
@synthesize returnedRecipeCourse;
@synthesize returnedRecipeRating;
@synthesize returnedRecipeFlavors;
@synthesize returnedRecipeTotalTimeInSeconds;
@synthesize returnedRecipeYield;
@synthesize returnedRecipeImagesArray;
@synthesize returnedRecipeMediumImage;
@synthesize returnedRecipeImagesDictionary;
@synthesize returnedRecipeNumberOfServings;


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
    
    numberOfTimesPlistSaved = 0;
    

    currentDate = [NSDate date];
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    components = [[NSDateComponents alloc] init];
//    [components setDay:1];
//    currentDate = [calendar dateByAddingComponents:components
//                                            toDate:currentDate
//                                           options:0];
    
    NSLog(@"Date Plus 1 = %@", currentDate);
    
    
    
    
    //create array from Plist document of all mountains
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
    allMeals = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath]mutableCopy];
    NSLog(@"%@", [allMeals objectAtIndex:0]);
    currentMeal = [[NSMutableArray alloc] init];
    currentMeal = [allMeals objectAtIndex:0];
    
    
    mealNumber = 0;
    returnedRecipeNumberOfServings = @"2";
    returnedRecipeID =@"";
    returnedRecipeTotalTimeInSeconds = @"";
    returnedRecipeYield = @"";
    returnedRecipeRating = @"";
    returnedRecipeName = @"";
    returnedRecipeMediumImage = @"";
    
    returnedRecipeImagesArray = [[NSMutableArray alloc] init];
    returnedRecipeImagesDictionary = [[NSMutableDictionary alloc] init];

    
    returnedRecipeFlavors = [[NSMutableDictionary alloc] init];
    
    [self testEdit];
    
    
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
                            self.caloriesForFats = [[object valueForKey:@"caloriesDedicatedToFats"] intValue];
                            self.caloriesForProteins = [[object valueForKey:@"caloriesDedicatedToProteins"] intValue];
                            self.caloriesForCarbs = [[object valueForKey:@"caloriesDedicatedToCarbs"] intValue];
                            self.caloriesForDay = [[object valueForKey:@"totalDailyCalories"] intValue];
                            self.calcium = [[object valueForKey:@"calcium"] intValue];
                            self.cholesterol = [[object valueForKey:@"cholesterol"] intValue];
                            self.fiber = [[object valueForKey:@"fiber"] intValue];
                            self.iron = [[object valueForKey:@"iron"] intValue]/3;
                            self.potassium = [[object valueForKey:@"potassium"] intValue];
                            self.sodium = [[object valueForKey:@"sodium"] intValue];
                            self.sugar = [[object valueForKey:@"sugar"] intValue];
                            self.vitaminA = [[object valueForKey:@"vitaminA"] intValue];
                            self.vitaminC = [[object valueForKey:@"vitaminC"] intValue];
                            
                            [self pupJesusIsBorn];
                            
                    
                        
                    }
                }
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
        
          }];
    
    

}

- (void) testEdit {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSLog(@"Current Meal: %@", allMeals);
    for (NSDictionary *object in allMeals) {
        NSLog(@"Object: %@", object);
        if ([[object objectForKey:@"Recipe Number"] isEqualToString:@"1"]) {
            [tempArray insertObject:object atIndex:0];
            NSLog(@"Temp Array: %@", tempArray);
        }
    }
    NSMutableDictionary *dictsy = [tempArray objectAtIndex:0];
    [dictsy setObject:@"Test Object" forKey:@"Test Key"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeName] forKey:@"Recipe Name"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeMediumImage] forKey:@"Hosted Medium URL"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeNumberOfServings] forKey:@"Number Of Servings"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeRating] forKey:@"Rating"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeYield] forKey:@"Yield"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeID] forKey:@"Recipe Id"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeTotalTimeInSeconds] forKey:@"Total Time In Seconds"];
    NSLog(@"Dictsy: %@", dictsy);

    
    NSLog(@"time: %@", returnedRecipeTotalTimeInSeconds);
    NSLog(@"med ima: %@", returnedRecipeMediumImage);
    NSLog(@"num ser: %@", returnedRecipeNumberOfServings);
    NSLog(@"ratig: %@", returnedRecipeRating);
    NSLog(@"yield: %@", returnedRecipeYield);
    NSLog(@"id: %@", returnedRecipeID);

    [allMeals replaceObjectAtIndex:0 withObject:dictsy];
    NSLog(@"ALL MEALS RIGHT HERE: %@", allMeals);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
    [allMeals writeToFile:path atomically:YES];
}

- (void) pupJesusIsBorn {
    
    NSLog(@"Pup");
    
    NSArray *arrayOfBreakfast = [[NSArray alloc] initWithObjects:@"Eggs", @"Potatoes", @"Pancakes", @"Pancakes", @"Potatoes", @"Eggs",@"Pancakes",nil];
    NSArray *arrayOfLunch = [[NSArray alloc] initWithObjects:@"Hamburger", @"Sandwhich", @"Macaroni", @"Macaroni",@"Sandwhich",@"Hamburger", @"Macaroni", @"Sandwhich", @"Macaroni",@"Hamburger", @"Sandwhich", @"Macaroni", @"Hamburger", @"Sandwhich", @"Macaroni", @"Macaroni",@"Sandwhich",@"Hamburger", @"Macaroni", @"Sandwhich", @"Macaroni",@"Hamburger", @"Sandwhich", nil];
    NSArray *arrayOfDinner = [[NSArray alloc] initWithObjects:@"Hotdog", @"Fish", @"Sushi", @"Pasta",  @"Fish", @"Sushi", @"Sushi", @"Pasta", @"Hotdog", @"Fish", @"Fish", @"Sushi", @"Pasta",  @"Fish", @"Sushi", @"Hotdog", @"Fish", @"Sushi", @"Pasta",  @"Fish", @"Sushi", @"Sushi", @"Pasta", @"Hotdog", @"Fish", @"Fish", @"Sushi", @"Pasta",  @"Fish",nil];

    NSString *stringForBreakfast = [[NSString alloc] init];
    NSString *stringForLunch = [[NSString alloc] init];
    NSString *stringForDinner = [[NSString alloc] init];
    
    NSString *searchFor = [[NSString alloc] init];
    
    int caloriesForFat = 0;
    int caloriesForProteins = 0;
    int caloriesForCarbs = 0;

    
    self.caloriesDedicatedToBreakfast = self.caloriesForDay * 0.25;
    self.caloriesDedicatedToLunch = self.caloriesForDay * 0.4;
    self.caloriesDedicatedToSnackBetweenLunchAndDinner = self.caloriesForDay * 0.1;
    self.caloriesDedicatedToDinner = self.caloriesForDay * 0.25;
    
    NSLog(@"Value for fats here %d", self.caloriesForFats);
    
    
        
        switch (self.i) {
            case 0:
                self.mealString = kSMBreakfast;
                self.caloriesForFatsForBreakfast = self.caloriesForFats * 0.2;
                self.caloriesForProteinsForBreakfast = self.caloriesForProteins * 0.2;
                self.caloriesForCarbsForBreakfast = self.caloriesForCarbs * 0.3;
                
                caloriesForFat = self.caloriesForFatsForBreakfast;
                caloriesForProteins = self.caloriesForProteinsForBreakfast;
                caloriesForCarbs = self.caloriesForCarbsForBreakfast;

                
                stringForBreakfast = [arrayOfBreakfast objectAtIndex:self.timeForPup];
                searchFor = stringForBreakfast;
                NSLog(@"Search for Bre :%@", searchFor);

                break;
            case 1:
                self.mealString = kSMLunchAndSnacks;
                self.caloriesForFatsForLunch = self.caloriesForFats * 0.4;
                self.caloriesForProteinsForLunch = self.caloriesForProteins * 0.45;
                self.caloriesForCarbsForLunch = self.caloriesForCarbs * 0.4;
                
                caloriesForFat = self.caloriesForFatsForBreakfast;
                caloriesForProteins = self.caloriesForProteinsForBreakfast;
                caloriesForCarbs = self.caloriesForCarbsForBreakfast;

                stringForLunch = [arrayOfLunch objectAtIndex:self.timeForPup];
                searchFor = stringForLunch;
                NSLog(@"Search for Lunch :%@", searchFor);

                break;
            default:
                self.mealString = kSMMainDishes;
                self.caloriesForFatsForDinner = self.caloriesForFats * .2;
                self.caloriesForProteinsForDinner = self.caloriesForProteins * .2;
                self.caloriesForCarbsForDinner = self.caloriesForCarbs * .3;
                
                caloriesForFat = self.caloriesForFatsForBreakfast;
                caloriesForProteins = self.caloriesForProteinsForBreakfast;
                caloriesForCarbs = self.caloriesForCarbsForBreakfast;

                stringForDinner = [arrayOfDinner objectAtIndex:self.timeForPup];
                searchFor = stringForDinner;
                NSLog(@"Search for Dinner :%@", searchFor);



                self.i = 0;
                break;
        }

        self.timeForPup ++;

        NSLog(@"Meal str: %@", self.mealString);
    
        [client searchForRecipe:searchFor meal:self.mealString allergies:self.allergiesArray valueForCarbs:caloriesForCarbs valueForFats:caloriesForFat valueForProteins:caloriesForProteins ];
    
    //valueForCalcium:self.calcium valueForCholesterol:self.cholesterol valueForFiber:self.fiber valueForIron:self.iron valueForPotassium:self.potassium valueForSodium:self.sodium valueForSugar:self.sugar valueForVitaminA:self.vitaminA valueForVitaminC:self.vitaminC
    
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
    
    mealNumber ++;
    
    // Create the dictionary and set the key mapping structure
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [dicts objectForKey:@"matches"];
    
    //NSLog(@"test %@", test);
    
    NSArray* listOfMatchingFoods = [dicts objectForKey:@"matches"]; //2
    
    if (listOfMatchingFoods == nil || [listOfMatchingFoods count] == 0) {
        [self pupJesusIsBorn];
    } else {
    
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:0];
    
    
    
    self.testValue ++;
    NSLog(@"Best Food Match: %@", bestFoodMatch);
    
    returnedRecipeID = [bestFoodMatch objectForKey:@"id"];
    returnedRecipeName = [bestFoodMatch objectForKey:@"recipeName"];
    returnedRecipeTotalTimeInSeconds = [bestFoodMatch objectForKey:@"totalTimeInSeconds"];
    returnedRecipeRating = [bestFoodMatch objectForKey:@"rating"];
    
    
    NSLog(@"Recipe Name: %@", returnedRecipeName);
//    NSLog(@"Recipe total time in sec: %@", totalTimeInSeconds);
//    NSLog(@"Recipe id: %@", id);
    
    // Create the get client to return the recipe (This just returns the first food from the search)
    SMYummlyGetClient *getClient = [SMYummlyGetClient sharedSMYummlyGetHTTPClient];
    getClient.delegate = self;
    [getClient findRecipeWithId:returnedRecipeID];
    }
}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didUpdateWithRecipe:(id)recipe {
    dict = recipe;
    [self logRecipe];
}

- (void) logRecipe {
    
//    NSLog(@"ingredientLines: %@", [dict objectForKey:@"ingredientLines"]);
//    NSLog(@"flavors: %@", [dict objectForKey:@"flavors"]);
//    //NSLog(@"nutritionEstimates: %@", [dict objectForKey:@"nutritionEstimates"]);
//    NSLog(@"numberOfServings: %@", [dict objectForKey:@"numberOfServings"]);
//    NSLog(@"yield: %@", [dict objectForKey:@"yield"]);
//    NSLog(@"name: %@", [dict objectForKey:@"name"]);
    
    NSArray *listOfMatchingCuisines = [dicts objectForKey:@"attribute"];
    NSArray *bestFoodMatch = [listOfMatchingCuisines objectAtIndex:1];
    //NSLog(@"Best Meal Match = %@", bestFoodMatch);
    
    returnedRecipeYield = [dict objectForKey:@"yield"];
    returnedRecipeNumberOfServings = [dict objectForKey:@"numberOfServings"];

    returnedRecipeImagesArray = [dict objectForKey:@"images"];
    //NSLog(@"HEre are images: %@", returnedRecipeImagesArray);
    
    returnedRecipeImagesDictionary = returnedRecipeImagesArray[0];
    //NSLog(@"Here is the image dict: %@", returnedRecipeImagesDictionary);

    returnedRecipeMediumImage = returnedRecipeImagesDictionary[@"hostedLargeUrl"];
    //NSLog(@"Here is the medium image: %@", returnedRecipeMediumImage);
    
    if (mealNumber == 2) {
        NSURL *url = [[NSURL alloc] initWithString:self.returnedRecipeMediumImage];
        PAImageView *avatarView = [[PAImageView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 200, 200) backgroundProgressColor:[UIColor lightGrayColor] progressColor:[UIColor redColor]];
        avatarView.center = CGPointMake(self.view.center.x, self.view.center.y);
        [self.view addSubview:avatarView];
        // Later
        [avatarView setImageURL:url];
    }
    
    if (mealNumber < 8) {
        
//        //create array from Plist document of all mountains
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory =  [paths objectAtIndex:0];
//        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
//        allMeals = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath]mutableCopy];

        //[self testEdit];

        
        [self savePlistInfo:mealNumber];

        [self pupJesusIsBorn];

    }
    
    
}

- (void) savePlistInfo:(int)meal {
    
    
    NSString *mealNumberString = [[NSString alloc] initWithFormat:@"%d",meal];
    NSLog(@"MEAL STRING NUMBER: %@", mealNumberString);
    int x = mealNumber - 1;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    //NSLog(@"Current Meal: %@", allMeals);
    for (NSDictionary *object in allMeals) {
        //NSLog(@"Object: %@", object);
        if ([[object objectForKey:@"Recipe Number"] isEqualToString:[NSString stringWithFormat:@"%d", meal]]) {
            [tempArray insertObject:object atIndex:0];
            NSLog(@"Temp Array: %@", tempArray);
        }
    }
    
    NSMutableDictionary *dictsy = [tempArray objectAtIndex:0];
    
    if (numberOfTimesPlistSaved > 3) {
        [components setDay:1];
        currentDate = [calendar dateByAddingComponents:components
                                                toDate:currentDate
                                               options:0];
        numberOfTimesPlistSaved = 0;
    }
    
    
    numberOfTimesPlistSaved ++;

    [dictsy setObject:currentDate forKey:@"Date For Meal"];
    [dictsy setObject:@"Test Object" forKey:@"Test Key"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeName] forKey:@"Recipe Name"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeMediumImage] forKey:@"Hosted Medium URL"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeNumberOfServings] forKey:@"Number Of Servings"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeRating] forKey:@"Rating"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeYield] forKey:@"Yield"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeID] forKey:@"Recipe Id"];
    [dictsy setObject:[NSString stringWithFormat:@"%@",returnedRecipeTotalTimeInSeconds] forKey:@"Total Time In Seconds"];
    
    
    
    
    
    [allMeals replaceObjectAtIndex:x withObject:dictsy];
    NSLog(@"ALL MEALS RIGHT HERE: %@", allMeals);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
    [allMeals writeToFile:path atomically:YES];
    
    NSLog(@"ALLL MEALS HERE: %@", allMeals);

    
    
    
    
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

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController.toolbar setHidden: YES];
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
