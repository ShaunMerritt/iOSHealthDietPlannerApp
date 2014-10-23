 //
//  SMMealPlanTableViewController.m
//  Elu
//
//  Created by Shaun Merritt on 9/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMMealPlanTableViewController.h"
#import "VENSeparatorTableViewCellProvider.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SMRecipeDetailViewController.h"
#import "DIDatepicker.h"
#import "Meal.h"
#import "SMAppDelegate.h"
#import "SMConstants.h"

@interface SMMealPlanTableViewController () {
    NSDate *currentDate;
    NSDate *datePicked;
    NSDate *_dateChosenByUser;
    
    NSMutableDictionary *dicts;
    NSMutableDictionary *dict;
    SMYummlyHTTPClient *client;
    NSDate *currentDateForGeneration;
    NSCalendar *calendar;
    NSDateComponents *components;
    int numberOfTimesPlistSaved;
    double numberOfMealsCreated;
    int numberOfDaysOfMealsCreated;
    int _currentDayOfWeek;
    int _mealNumberForDay;
    int _maxTimeInSeconds;
    int _totalMealsToGenerateIfTodayIsNotSunday;
    int _caloriesForMeal;
    int _minNumberCaloriesForMeal;
    int _maxNumberOfCaloriesForMeal;
}

@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;




@end

@implementation SMMealPlanTableViewController
@synthesize allMeals;
@synthesize fetchedResultsContoller = _fetchedResultsContoller;

@synthesize allMealsForGeneration;
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    numberOfDaysOfMealsCreated = 1;
    _dateChosenByUser = [NSDate date];
    
    SMAppDelegate *myid = [[UIApplication sharedApplication] delegate];
    
    _managedObjectContext = myid.managedObjectContext;
    
    [self updateSelectedDate];
    
    NSError *error;
    if (![[self fetchedResultsContoller] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    [self.datepicker fillCurrentWeek];
    [self.datepicker selectDateAtIndex:0];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    currentDateForGeneration = [NSDate date];
    
    
    returnedRecipeImagesArray = [[NSMutableArray alloc] init];
    returnedRecipeImagesDictionary = [[NSMutableDictionary alloc] init];
    _allIngredientsArray = [[NSMutableArray alloc] init];
    
    
    
    returnedRecipeFlavors = [[NSMutableDictionary alloc] init];
    
    self.mealString = [[NSString alloc] init];
    
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Meal"];
    request.predicate = [NSPredicate predicateWithFormat:@"dateForMeal == %@", [self dateWithoutTime]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateForMeal" ascending:YES]];
    
    NSArray *results = [_managedObjectContext executeFetchRequest:request error:nil];
    
    if([results count] > 1) {
        NSLog(@"No thanks today");
    } else {
    
    
    
    
        if ([self isCurrentDayLastDayOfWeek] == YES || _totalMealsToGenerateIfTodayIsNotSunday > 0) {
            
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
            _maxTimeInSeconds = 60 * 30;
            
            _caloriesForMeal = self.caloriesDedicatedToBreakfast;
            
            
            
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
            _maxTimeInSeconds = 60 * 30;
            
            
            _caloriesForMeal = self.caloriesDedicatedToLunch;

            
            
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
            _maxTimeInSeconds = 60 * 20;
            
            
            
            _caloriesForMeal = self.caloriesDedicatedToSnackBetweenLunchAndDinner;

            
            
            
            
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
            _maxTimeInSeconds = 60 * 45;
            
            
            
            
            _caloriesForMeal = self.caloriesDedicatedToDinner;

            
            
            
            
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
    
    [client searchForRecipe:searchFor meal:self.mealString allergies:self.allergiesArray valueForCarbs:caloriesForCarbs valueForFats:caloriesForFat valueForProteins:caloriesForProteins maxTimeInSeconds:_maxTimeInSeconds minNumberOfCalories:_caloriesForMeal  maxNumberOfCalories:_caloriesForMeal] ;
    
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

- (BOOL) isCurrentDayLastDayOfWeek {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsForWeekdayCalculation = [gregorianCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    _currentDayOfWeek = (int)[componentsForWeekdayCalculation weekday];
    
    //NSLog(@"Current Day Of Week: %d", _currentDayOfWeek);
    
    if (_currentDayOfWeek == 1) {
        NSLog(@"1");
        return YES;
    } else {
        _totalMealsToGenerateIfTodayIsNotSunday = (7 - _currentDayOfWeek) * 4;
        NSLog(@"Total Meals to generate: %d", _totalMealsToGenerateIfTodayIsNotSunday);
        NSLog(@"Curent day of week %d", _currentDayOfWeek);
        
    }
    
    return NO;
    
    
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
    
    
    if ([self isCurrentDayLastDayOfWeek] == YES) {

        if (numberOfMealsCreated < 28) {
        
        
        
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
            
    } else if (numberOfMealsCreated < _totalMealsToGenerateIfTodayIsNotSunday + 4) {
    
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
                         
- (NSDate *)dateWithoutTime {
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:0 toDate:[NSDate date] options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendarForDatePicker = [NSCalendar currentCalendar];
    
    NSDateComponents* componentsForDatePicker = [calendarForDatePicker components:flags fromDate:nextDate];
    
    NSDate* dateOnly = [calendarForDatePicker dateFromComponents:componentsForDatePicker];
 
    return dateOnly;
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


// Implementing data source methods
- (NSInteger) numberOfMenuItems
{
    return 3;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"facebook";
            break;
        case 1:
            imageName = @"twitter";
            break;
        case 2:
            imageName = @"google-plus";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            msg = @"Facebook Selected";
            break;
        case 1:
            msg = @"Twitter Selected";
            break;
        case 2:
            msg = @"Google Plus Selected";
            break;
            
        default:
            break;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsContoller sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsContoller sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForRestOfFoods" forIndexPath:indexPath];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    Meal *meal = [self.fetchedResultsContoller objectAtIndexPath:indexPath];
    cell.textLabel.text = meal.recipeName;
    
    UIImageView *imageHolder = (UIImageView *)[cell viewWithTag:1];
    
    NSURL *url = [NSURL URLWithString:meal.imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    __weak UITableViewCell *weakCell = cell;
    
    [imageHolder setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    
                                    weakCell.backgroundView = [[UIImageView alloc] initWithImage:image];
                                    
                                    [weakCell setNeedsLayout];
                                    
                                } failure:nil];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;

}

#pragma mark - VENTableViewSeparatorProviderDelegate methods

- (BOOL)isCellJaggedAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
    
}


#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *) fetchedResultsContoller {
    if (_fetchedResultsContoller != nil) {
        return _fetchedResultsContoller;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meal" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateForMeal == %@", _dateChosenByUser];
    [fetchRequest setPredicate:predicate];
    
    //TODO: change sort to meal number
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mealNumber"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsContoller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsContoller.delegate = self;
    
    return _fetchedResultsContoller;
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            Meal *changedCourse = [self.fetchedResultsContoller objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedCourse.recipeName;
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

    
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
         //TODO: add handler for going to detail view
         SMRecipeDetailViewController *rDVC = (SMRecipeDetailViewController *)[segue destinationViewController];
         NSIndexPath *path = [self.tableView indexPathForSelectedRow];
         Meal *selectedMeal = (Meal *) [self.fetchedResultsContoller objectAtIndexPath:path];
         rDVC.currentMeal = selectedMeal;
         
     }
     
     if ([segue.identifier isEqualToString:@"showShoppingList"]) {
         [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
     }
 }

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    self.managedObjectContext = context;
    return context;
}


- (void)updateSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendarForDatePicker = [NSCalendar currentCalendar];
    NSDateComponents* componentsForDatePicker = [[NSDateComponents alloc] init];
    
    if (self.datepicker.selectedDate != nil) {
        componentsForDatePicker = [calendarForDatePicker components:flags fromDate:self.datepicker.selectedDate];
        NSDate* dateOnly = [calendarForDatePicker dateFromComponents:componentsForDatePicker];
        
        _dateChosenByUser = dateOnly;
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"dateForMeal == %@", _dateChosenByUser];
        [_fetchedResultsContoller.fetchRequest setPredicate:predicate];
        
        //TODO: change sort to meal number
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mealNumber"
                                                                       ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject: sortDescriptor];
        [[_fetchedResultsContoller fetchRequest] setSortDescriptors:sortDescriptors];
        
        
        NSError *error = nil;
        if (![[self fetchedResultsContoller] performFetch:&error]) {
            // Handle error
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
        [self.tableView reloadData];
    } else {
        componentsForDatePicker = [calendarForDatePicker components:flags fromDate:[NSDate date]];
        
        
    }

    
    NSDate* dateOnly = [calendarForDatePicker dateFromComponents:componentsForDatePicker];
    
    NSLog(@"Date only: %@", dateOnly);
    
    NSLog(@"Date: %@", self.datepicker.selectedDate);
    
    _dateChosenByUser = dateOnly;
    
}

@end
