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
#import "DCPathButton.h"
#import "SMNutritionixClient.h"
#import "YLLongTapShareView.h"
#import "UIButton+LongTapShare.h"
#import "DCPathButton.h"
#import "SMWaterLogViewController.h"
#import "SMExerciseLoggingViewController.h"
#import "Patient.h"
#import "SMSaveCaloricInfoToParse.h"
#import "SMLoginViewController.h"
#import <PNChart.h>


@interface SMHomeScreenViewController () <DCPathButtonDelegate>{
    NSMutableDictionary *dicts;
    NSMutableDictionary *dict;
    SMYummlyHTTPClient *client;
    NSDate *currentDate;
    NSCalendar *calendar;
    NSDateComponents *components;
    int numberOfTimesPlistSaved;
    double numberOfMealsCreated;
    int numberOfDaysOfMealsCreated;
    int _currentDayOfWeek;
    int _mealNumberForDay;
    
    NSArray *returnedFoods;
    NSArray *returnedRecipe;
    NSDictionary *dictionary;
    NSDictionary *dictionarys;
    NSDictionary *itemsReturned;
    NSDictionary *infoFromUPCScanReturned;
    NSString *doctorChosenDietURL;
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
@synthesize returnedRecipeWebsiteURL;
@synthesize returnedRecipeNumberCalories;


#pragma mark - Lifecycle

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
    _managedObjectContext = [self managedObjectContext];

    
    [super viewDidLoad];
    
    DCPathButton *centerButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    [self.tabBarController.view addSubview:centerButton];
    
    centerButton.delegate = self;
    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"CameraIcon"]
                                                           highlightedImage:[UIImage imageNamed:@"CameraIcon"]
                                                            backgroundImage:[UIImage imageNamed:@"CameraIcon"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"CameraIcon"]];
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"SearchIcon"]
                                                           highlightedImage:[UIImage imageNamed:@"SearchIcon"]
                                                            backgroundImage:[UIImage imageNamed:@"SearchIcon"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"SearchIcon"]];
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"WaterIcon"]
                                                           highlightedImage:[UIImage imageNamed:@"WaterIcon"]
                                                            backgroundImage:[UIImage imageNamed:@"WaterIcon"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"WaterIcon"]];
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"ExerciseIcon"]
                                                           highlightedImage:[UIImage imageNamed:@"ExerciseIcon"]
                                                            backgroundImage:[UIImage imageNamed:@"ExerciseIcon"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"ExerciseIcon"]];
    
    [centerButton addPathItem:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4]];
    
    NSLog(@"added");


    
    currentDate = [NSDate date];
    
    
    returnedRecipeImagesArray = [[NSMutableArray alloc] init];
    returnedRecipeImagesDictionary = [[NSMutableDictionary alloc] init];
    _allIngredientsArray = [[NSMutableArray alloc] init];
    

    
    returnedRecipeFlavors = [[NSMutableDictionary alloc] init];
    
    self.mealString = [[NSString alloc] init];
    

    if ([self isCurrentDayLastDayOfWeek] == YES) {
        
        _mealNumberForDay = 0;
    
        // Query for objects in class DietRestrictions with the same username as the current user
        PFQuery *query = [PFQuery queryWithClassName:@"CaloriesPerDay"];
        [query whereKey:@"user" equalTo:PFUser.currentUser];
        
        // Find the objects from the query
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // No error
                        //NSLog(@"Successfully retrieved %lu objects.", (unsigned long)objects.count);
                        // For each of the objects that is returned
                        client = [SMYummlyHTTPClient sharedSMYummlyHTTPClient];
                        client.delegate = self;

                            //NSLog(@"I is: %d", self.i);
                            for (PFObject *object in objects) {
                                //log the objects that we got back to the NSLOG
                                self.allergiesArray = [object valueForKey:@"arrayOfAllergies"];
                                self.caloriesForFats = [[object valueForKey:@"caloriesDedicatedToFats"] intValue]/9;
                                self.caloriesForProteins = [[object valueForKey:@"caloriesDedicatedToProteins"] intValue]/4;
                                self.caloriesForCarbs = [[object valueForKey:@"caloriesDedicatedToCarbs"] intValue]/4;
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
                                
                                //NSLog(@"hhhhh");
                                
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
            
              }];
    }
    

}

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    if(index == 0){
        // When the user tap index 1 here ...
        ZBarReaderViewController *reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        
        [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
        reader.readerView.zoom = 1.0;
        
        [self presentViewController:reader animated:YES completion:nil];
    }
    if (index == 1) {
        [self showLog];
    } if (index == 2) {
        SMWaterLogViewController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"logWater"];
        [self.navigationController pushViewController:secondViewController animated:YES];
        
    } else {
        // other code here ...
        NSLog(@"dsfdsf");
        SMExerciseLoggingViewController *exerciseLogViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ExerciseLog"];
        [self.navigationController pushViewController:exerciseLogViewController animated:YES];
    }
}

- (void) showLog {
    
    SMLogFoodTableViewController *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"logFood"];
    [self.navigationController pushViewController:secondViewController animated:YES];
    
}

- (void) testMethod {
    
    //[super viewDidLoad];
    
    //[self.view addSubview:self.view];
    //[self viewDidLoad];
    
    //[self.view setNeedsDisplay];
    
    
    
    NSLog(@"YAYAYA");
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;
    
    [self presentViewController:reader animated:YES completion:nil];
}


- (void)yourNewFunction
{
    //[self.view addSubview:self.view];
    
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    [reader.scanner setSymbology: ZBAR_UPCA config: ZBAR_CFG_ENABLE to: 0];
    reader.readerView.zoom = 1.0;
    
    [self presentViewController:reader animated:YES completion:nil];
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
    
    [self saveFoodToCoreDataWithAmountOfCalories: nf_calories];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YAY!!!" message:[NSString stringWithFormat:@"You scanned an item with the id: %@. The items name is: %@. The Brand Name is: %@. And it has %@ calories.", item_id, item_name, brand_name, nf_calories] delegate:nil cancelButtonTitle:@"Thanks" otherButtonTitles: nil];
    
    [alert show];
}

- (NSDate *)calculateCurrentDateWithTimeSetToZero {
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    return dateOnly;
    
}


- (void) saveFoodToCoreDataWithAmountOfCalories: (NSString *)calories {
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Patient" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"date == %@", [self calculateCurrentDateWithTimeSetToZero]];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    Patient *newVehicle = [results objectAtIndex:0];
    
    NSNumber *sum = [NSNumber numberWithFloat:([newVehicle.totalCaloriesEatenToday floatValue] + [calories floatValue])];
    [newVehicle setValue: sum forKey:@"totalCaloriesEatenToday"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesEatenTodayToParse:sum];
    
    
    NSNumber *sumOfTotalForDay = [NSNumber numberWithFloat:([newVehicle.totalCaloriesForDay floatValue] + [calories floatValue])];
    [newVehicle setValue: sumOfTotalForDay forKey:@"totalCaloriesForDay"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesForDayToParse:sumOfTotalForDay];
    
    
    [self.managedObjectContext save:nil];
    
    
    
    
    
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



#pragma mark - Helper Methods

- (NSArray *)arrayOfBreakfasts {
    
    return [[PFUser currentUser] objectForKey:@"Liked_Breakfast_Array"];
    
}

- (NSArray *)arrayOfLunch {
    
    return [[PFUser currentUser] objectForKey:@"Liked_Lunch_Array"];
    
}

- (NSArray *)arrayOfSnack {
    
    return [[PFUser currentUser] objectForKey:@"Liked_Snack_Array"];
    
}

- (NSArray *)arrayOfDinner {
    
    return [[PFUser currentUser] objectForKey:@"Liked_Dinner_Array"];
    
}

- (BOOL) isCurrentDayLastDayOfWeek {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsForWeekdayCalculation = [gregorianCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    _currentDayOfWeek = (int)[componentsForWeekdayCalculation weekday];
    
    //NSLog(@"Current Day Of Week: %d", _currentDayOfWeek);
    
    if (_currentDayOfWeek == 1) {
        NSLog(@"1");
        return YES;
    }

    return YES;
    
    
}

- (void) pupJesusIsBorn {
    
    //NSLog(@"Pup");
    
    
    
    NSArray *arrayOfBreakfast = [self arrayOfBreakfasts];
    NSArray *arrayOfLunch = [self arrayOfLunch];
    NSArray *arrayOfDinner = [self arrayOfDinner];
    NSArray *arrayOfSnack = [self arrayOfSnack];


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
    
    //NSLog(@"Value for fats here %d", self.caloriesForFats);
    
    
        
        switch (_mealNumberForDay) {
            case 0:
                self.mealString = kSMBreakfast;
                self.caloriesForFatsForBreakfast = self.caloriesForFats * 0.2;
                self.caloriesForProteinsForBreakfast = self.caloriesForProteins * 0.2;
                self.caloriesForCarbsForBreakfast = self.caloriesForCarbs * 0.3;
                
                caloriesForFat = self.caloriesForFatsForBreakfast;
                caloriesForProteins = self.caloriesForProteinsForBreakfast;
                caloriesForCarbs = self.caloriesForCarbsForBreakfast;

                
                stringForBreakfast = [arrayOfBreakfast objectAtIndex: arc4random() % [arrayOfBreakfast count]];
                searchFor = stringForBreakfast;
                NSLog(@"Search for Bre :%@", searchFor);
                _mealNumberForDay ++;


                break;
            case 1:
                self.mealString = kSMLunchAndSnacks;
                self.caloriesForFatsForLunch = self.caloriesForFats * 0.4;
                self.caloriesForProteinsForLunch = self.caloriesForProteins * 0.45;
                self.caloriesForCarbsForLunch = self.caloriesForCarbs * 0.4;
                
                caloriesForFat = self.caloriesForFatsForLunch;
                caloriesForProteins = self.caloriesForProteinsForLunch;
                caloriesForCarbs = self.caloriesForCarbsForLunch;

                stringForLunch = [arrayOfLunch objectAtIndex: arc4random() % [arrayOfLunch count]];
                searchFor = stringForLunch;
                NSLog(@"Search for Lunch :%@", searchFor);
                _mealNumberForDay ++;


                break;
            case 2:
                self.mealString = kSMLunchAndSnacks;
                self.caloriesForFatsForLunch = self.caloriesForFats * 0.2;
                self.caloriesForProteinsForLunch = self.caloriesForProteins * 0.25;
                self.caloriesForCarbsForLunch = self.caloriesForCarbs * 0.2;
                
                caloriesForFat = self.caloriesForFatsForLunch;
                caloriesForProteins = self.caloriesForProteinsForLunch;
                caloriesForCarbs = self.caloriesForCarbsForLunch;
                
                stringForLunch = [arrayOfSnack objectAtIndex: arc4random() % [arrayOfSnack count]];
                searchFor = stringForLunch;
                NSLog(@"Search for Lunch :%@", searchFor);
                _mealNumberForDay ++;
                
                break;
                
            default:
                self.mealString = kSMMainDishes;
                self.caloriesForFatsForDinner = self.caloriesForFats * .2;
                self.caloriesForProteinsForDinner = self.caloriesForProteins * .2;
                self.caloriesForCarbsForDinner = self.caloriesForCarbs * .3;
                
                caloriesForFat = self.caloriesForFatsForDinner;
                caloriesForProteins = self.caloriesForProteinsForDinner;
                caloriesForCarbs = self.caloriesForCarbsForDinner;

                stringForDinner = [arrayOfDinner objectAtIndex: arc4random() % [arrayOfDinner count]];
                searchFor = stringForDinner;
                NSLog(@"Search for Dinner :%@", searchFor);



                _mealNumberForDay = 0;
                self.i = 0;
                break;
        }

        self.timeForPup ++;

        NSLog(@"Meal str: %@", self.mealString);
    
        [client searchForRecipe:searchFor meal:self.mealString allergies:self.allergiesArray valueForCarbs:caloriesForCarbs valueForFats:caloriesForFat valueForProteins:caloriesForProteins maxTimeInSeconds:100 minNumberOfCalories:0 maxNumberOfCalories:0 ];
    
    //valueForCalcium:self.calcium valueForCholesterol:self.cholesterol valueForFiber:self.fiber valueForIron:self.iron valueForPotassium:self.potassium valueForSodium:self.sodium valueForSugar:self.sugar valueForVitaminA:self.vitaminA valueForVitaminC:self.vitaminC
    
    
    
}

- (void) log {
    
    
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
    //NSLog(@"Best Food Match: %@", bestFoodMatch);
    
    returnedRecipeID = [bestFoodMatch objectForKey:@"id"];
    returnedRecipeName = [bestFoodMatch objectForKey:@"recipeName"];
    returnedRecipeTotalTimeInSeconds = [bestFoodMatch objectForKey:@"totalTimeInSeconds"];
    returnedRecipeRating = [bestFoodMatch objectForKey:@"rating"];
        
        NSArray *ingredientsArray = [bestFoodMatch objectForKey:@"ingredients"];
        
        NSLog(@"ingredients = %@", ingredientsArray);
        
        [_allIngredientsArray addObjectsFromArray:ingredientsArray];
            
//        for (NSString *name in ingredientsArray) {
//            
//            
//            
//            
//            
//            NSManagedObjectContext *context = [self managedObjectContext];
//            NSManagedObject *mealObject = [NSEntityDescription
//                                           insertNewObjectForEntityForName:@"Ingredients"
//                                           inManagedObjectContext:context];
//            
//            
//            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ingredients" inManagedObjectContext:context];
//            [fetchRequest setEntity:entity];
//            // Specify criteria for filtering which objects to fetch
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ingredientsName == %@", name];
//            [fetchRequest setPredicate:predicate];
//            // Specify how the fetched objects should be sorted
//            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ingredientsName"
//            ascending:YES];
//            [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//
//            NSError *error = nil;
//            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//            if (fetchedObjects == nil) {
//                
//                
//                NSLog(@"HEEEEEEEEERRRRRRRRRRREEEEEEE");
//                
//                [mealObject setValue:[NSString stringWithFormat:@"%@",name] forKey:@"ingredientsName"];
//                
//                NSError *error;
//                if (![context save:&error]) {
//                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//                }
//
//            } else {
//                NSLog(@"Already Exists");
//            }
//            
//            
//            
//        }
//    
        
        
        
        
        
        
        // Get the names to parse in sorted order.
        
        
        
    
    //NSLog(@"Recipe Name: %@", returnedRecipeName);
//    NSLog(@"Recipe total time in sec: %@", totalTimeInSeconds);
//    NSLog(@"Recipe id: %@", id);
    
    // Create the get client to return the recipe (This just returns the first food from the search)
    SMYummlyGetClient *getClient = [SMYummlyGetClient sharedSMYummlyGetHTTPClient];
    getClient.delegate = self;
    [getClient findRecipeWithId:returnedRecipeID];
    }
}

- (void) logRecipe {
    
    numberOfMealsCreated ++;
    
    NSArray *listOfMatchingCuisines = [dicts objectForKey:@"attribute"];
    //NSLog(@"Best Meal Match = %@", bestFoodMatch);
    
    returnedRecipeYield = [dict objectForKey:@"yield"];
    returnedRecipeNumberOfServings = [dict objectForKey:@"numberOfServings"];

    returnedRecipeImagesArray = [dict objectForKey:@"images"];
    //NSLog(@"HEre are images: %@", returnedRecipeImagesArray);
    
    returnedRecipeImagesDictionary = returnedRecipeImagesArray[0];
    //NSLog(@"Here is the image dict: %@", returnedRecipeImagesDictionary);

    returnedRecipeMediumImage = returnedRecipeImagesDictionary[@"hostedLargeUrl"];
    //NSLog(@"Here is the medium image: %@", returnedRecipeMediumImage);
    
    NSDictionary *dicti = [[NSDictionary alloc] init];
    dicti = [dict objectForKey:@"attribution"];
    returnedRecipeWebsiteURL = [dicti objectForKey:@"url"];
    
    NSArray *array = [[NSArray alloc] init];
    array = [dict objectForKey:@"nutritionEstimates"];
    
    //NSLog(@"0 is here: %@", array);

    
    NSDictionary *dis = [[NSDictionary alloc] init];
    dis = array[0];
    
    
    returnedRecipeNumberCalories = [dis objectForKey:@"value"];
    
    NSLog(@"One is here: %@", returnedRecipeNumberCalories);

    
    if (numberOfMealsCreated < 28) {
        
        
        if ([self isCurrentDayLastDayOfWeek] == YES) {
            
            if (fmodf(numberOfMealsCreated, 4) == 0 || numberOfMealsCreated == 0) {
                NSLog(@"YAYAYAYAYAYAYAYAYAYAYAYAAYAYYAYAYAYAYA");
                NSLog(@"number of meals: %f", numberOfMealsCreated);
                numberOfDaysOfMealsCreated ++;
//                if (fmod(_mealNumberForDay, 0) == 0 || _mealNumberForDay == 0) {
//                    _mealNumberForDay = 1;
//                } else if (fmod(_mealNumberForDay, 1) == 0) {
//                    _mealNumberForDay = 2;
//                } else if (fmod(_mealNumberForDay, 2) == 0) {
//                    _mealNumberForDay = 3;
//                } else if (fmod(_mealNumberForDay, 3) == 0) {
//                    _mealNumberForDay = 4;
//                }
            }
            
            [self savePlistInfo:mealNumber];
            
            [self pupJesusIsBorn];
            
        }
        

    } else {
        
        
        NSArray *cleanedArray = [[NSSet setWithArray:_allIngredientsArray] allObjects];
        NSLog(@"cleaned array: %@", cleanedArray);
        NSLog(@"_all ingredients %@", _allIngredientsArray);
        
        for (NSString *name in cleanedArray) {

            NSManagedObjectContext *context = [self managedObjectContext];
            NSManagedObject *mealObject = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Ingredients"
                                           inManagedObjectContext:context];
        
        
            [mealObject setValue:[NSString stringWithFormat:@"%@",name] forKey:@"ingredientsName"];

            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        
        
        
        
        
        
//        NSManagedObjectContext *context = [self managedObjectContext];
//        
//        
//        
//        NSArray *employeeIDs = [_allIngredientsArray sortedArrayUsingSelector: @selector(compare:)];
//        
//        
//        
//        // create the fetch request to get all Employees matching the IDs
//        
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        
//        [fetchRequest setEntity:
//         
//         [NSEntityDescription entityForName:@"Ingredients" inManagedObjectContext:context]];
//        
//        [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(ingredientsName IN %@)", employeeIDs]];
//        
//        
//        
//        // Make sure the results are sorted as well.
//        
//        [fetchRequest setSortDescriptors:
//         
//         @[ [[NSSortDescriptor alloc] initWithKey: @"employeeID" ascending:YES] ]];
//        
//        // Execute the fetch.
//        
//        NSError *error;
//        
//        NSArray *employeesMatchingNames = [context executeFetchRequest:fetchRequest error:&error];
//        
//        NSLog(@"matching: %@", employeesMatchingNames);
//        

    }
    
    
}

- (NSDate *)calculateDateToSaveOnMealFrom:(int)numberOfDays {
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = numberOfDays;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendarForDatePicker = [NSCalendar currentCalendar];
    
    NSDateComponents* componentsForDatePicker = [calendarForDatePicker components:flags fromDate:nextDate];
    
    NSDate* dateOnly = [calendarForDatePicker dateFromComponents:componentsForDatePicker];
    
    //NSLog(@"Date only: %@", dateOnly);

    
    return dateOnly;
}

- (void) savePlistInfo:(int)meal {
    
    int testNumber;

    if ([self.mealString isEqualToString:kSMBreakfast]) {
        testNumber = 1;
    } else if ([self.mealString isEqualToString:kSMLunchAndSnacks]) {
        testNumber = 2;
    } else {
        testNumber = 4;
    }

    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *mealObject = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Meal"
                                   inManagedObjectContext:context];
    
    [mealObject setValue:[NSString stringWithFormat:@"%@",returnedRecipeName] forKey:@"recipeName"];
    [mealObject setValue:[NSString stringWithFormat:@"%@",returnedRecipeMediumImage] forKey:@"imageURL"];
    [mealObject setValue:(returnedRecipeNumberOfServings) forKey:@"numberOfServings"];
    [mealObject setValue:(returnedRecipeRating) forKey:@"recipeRating"];
    //[mealObject setValue:(returnedRecipeYield) forKey:@"recipeYield"];
    [mealObject setValue:[NSString stringWithFormat:@"%@",returnedRecipeID] forKey:@"recipeID"];
    [mealObject setValue:[NSString stringWithFormat:@"%@",returnedRecipeWebsiteURL] forKey:@"recipeURL"];
    [mealObject setValue:[self calculateDateToSaveOnMealFrom:numberOfDaysOfMealsCreated] forKey:@"dateForMeal"];
    [mealObject setValue:@(testNumber) forKey:@"mealNumber"];
    [mealObject setValue:(returnedRecipeNumberCalories) forKey:@"numberOfCalories"];

    
    
    
    if (returnedRecipeTotalTimeInSeconds != nil) {
        //[mealObject setValue:(returnedRecipeTotalTimeInSeconds) forKey:@"timeInSeconds"];
    }
    
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    
    
    
}

#pragma mark - Yummly HTTP Client Delegate

- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didUpdateWithFood:(id)food {
    //NSLog(@"HERE");
    dicts = food;
    [self log];
}

- (void) yummlyHTTPClient:(SMYummlyHTTPClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil 			cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - Yummly Get HTTP Client Delegate

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString 						stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}

- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didUpdateWithRecipe:(id)recipe {
    dict = recipe;
    [self logRecipe];
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

#pragma mark - Core Data

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
