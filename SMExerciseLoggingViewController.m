//
//  SMExerciseLoggingViewController.m
//  Elu
//
//  Created by Shaun Merritt on 10/4/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

@import CoreData;
#import "SMExerciseLoggingViewController.h"

@interface SMExerciseLoggingViewController () {
    
    __weak IBOutlet UILabel *caloriesBurnedTodayLabel;
    __weak IBOutlet UITextField *newExerciseTextField;
    int _numberOfCaloriesBurnedToday;
    NSArray *reversedArray;
    
}

- (IBAction)addNewExerciseButtonClicked:(id)sender;

@end

@implementation SMExerciseLoggingViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //mainArray = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    //mainArray = [[mainArray reverseObjectEnumerator] allObjects];
    
    
    
    if ([self coreDataHasEntriesForEntityName:@"Exercise"] == YES) {
        NSLog(@"Exists");
        // Fetch the devices from persistent data store
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Exercise"];
        mainArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        NSManagedObject *currentDay = [mainArray objectAtIndex:mainArray.count - 1 ];
        
        
        _numberOfCaloriesBurnedToday = [[currentDay valueForKey:@"numberOfCalories"] intValue];
        caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d",_numberOfCaloriesBurnedToday];
        NSLog(@"HereL : %d",_numberOfCaloriesBurnedToday);
        
        
        NSDate *dateCreated = [currentDay valueForKey:@"dateLogged"];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dateCreated];
        
        NSDate *now = [NSDate date];
        
        // Creates an object representing the Gregorian calendar
        NSCalendar *calendars = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // Sets the calendar object with an object representing the time zone specified in System Preferences
        [calendars setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
        NSDateComponents *dcs = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
        
        // Logs the current hour, minute, and second to the console
        
        if (dcs.year != dc.year || dcs.month != dc.month || dcs.day != dc.day) {
            // Create a new managed object
            
            NSLog(@"Not some date");
            
            NSManagedObjectContext *context = [self managedObjectContext];
            _numberOfCaloriesBurnedToday = 0;

            // Create a new managed object
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:context];
            [newDevice setValue:@(_numberOfCaloriesBurnedToday) forKey:@"numberOfCalories"];
            caloriesBurnedTodayLabel.text = @"0";
            
            // Create a new managed object
            //NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Water" inManagedObjectContext:managedObjectContext];
            //[cupsOfWaterObject setValue:@(0) forKey:@"numberOfCups"];
            
            // Creates a date object representing the current date
            NSDate *now = [NSDate date];
            
            // Creates an object representing the Gregorian calendar
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            // Sets the calendar object with an object representing the time zone specified in System Preferences
            [calendar setTimeZone:[NSTimeZone systemTimeZone]];
            
            // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
            NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
            
            // Logs the current hour, minute, and second to the console
            NSLog(@"The time is %d:%d:%d", [dc year], [dc month], [dc day]);
            
            
            [newDevice setValue:now forKey:@"dateLogged"];
            caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d", _numberOfCaloriesBurnedToday];
            NSLog(@"calories = %d", _numberOfCaloriesBurnedToday);
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
            
        } else {
            NSLog(@"Same Date");
            // Fetch the devices from persistent data store
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Exercise"];
            mainArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            
                reversedArray = [[mainArray reverseObjectEnumerator] allObjects];
            
            
            
            NSManagedObject *currentDay = [reversedArray objectAtIndex:0];
            
            int test;
            
            test = [[currentDay valueForKey:@"numberOfCalories"] intValue];
            
            _numberOfCaloriesBurnedToday = test;
            
            caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d",test];
            NSDate *testDate = [currentDay valueForKey:@"dateLogged"];
            
            
            caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d",_numberOfCaloriesBurnedToday];
            NSLog(@"HereL : %d",_numberOfCaloriesBurnedToday);

            
            
            NSLocale *locale = [NSLocale currentLocale];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d yyyy" options:0 locale:locale];
            [formatter setDateFormat:dateFormat];
            [formatter setLocale:locale];
            
            
        }
        
        
    } else {
        NSLog(@"NONONOO");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        
        // Create a new managed object
        _exerciseObject = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:managedObjectContext];
        [_exerciseObject setValue:@(0) forKey:@"numberOfCalories"];
        
        // Creates a date object representing the current date
        NSDate *now = [NSDate date];
        
        // Creates an object representing the Gregorian calendar
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // Sets the calendar object with an object representing the time zone specified in System Preferences
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
        
        // Logs the current hour, minute, and second to the console
        _numberOfCaloriesBurnedToday = 0;
        caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d", _numberOfCaloriesBurnedToday];

        
        [_exerciseObject setValue:now forKey:@"dateLogged"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        
    }
    
    
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Exercise"];
    NSMutableArray *devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSManagedObject *selectedDevice = [devices objectAtIndex:(devices.count - 1)];
    
    
    
    
    
    
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [selectedDevice setValue:@(_numberOfCaloriesBurnedToday) forKey:@"numberOfCalories"];
    caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d", _numberOfCaloriesBurnedToday];
    [self saveToParse:_numberOfCaloriesBurnedToday];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (BOOL)coreDataHasEntriesForEntityName:(NSString *)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    [request setFetchLimit:1];
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Fetch error: %@", error);
        abort();
    }
    if ([results count] == 0) {
        return NO;
    }
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void) saveToParse:(int)numberOfCupsToSaveForParse {
    
    // Set the liked food array to Liked_Food_Array on Parse
    [[PFUser currentUser] setObject:@(numberOfCupsToSaveForParse) forKey:@"Number_Of_Calories_Burned_Today"];
    
    // Save the objects to parse
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    
}

#pragma mark - IBActions
- (IBAction)addNewExerciseButtonClicked:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    
    if (_numberOfCaloriesBurnedToday == 0) {
        
        NSLog(@"Herrrrr");
        
        _numberOfCaloriesBurnedToday = 0;
        caloriesBurnedTodayLabel.text = @"0";
        
        
        // Creates a date object representing the current date
        NSDate *now = [NSDate date];
        
        // Creates an object representing the Gregorian calendar
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // Sets the calendar object with an object representing the time zone specified in System Preferences
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
        
        // Logs the current hour, minute, and second to the console
        
        
        [_exerciseObject setValue:now forKey:@"dateLogged"];
        _numberOfCaloriesBurnedToday = [[newExerciseTextField text] intValue];
        caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d", _numberOfCaloriesBurnedToday];
        [_exerciseObject setValue:@(_numberOfCaloriesBurnedToday) forKey:@"numberOfCalories"];

        [self saveToParse:_numberOfCaloriesBurnedToday];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        
    } else {
        if (_numberOfCaloriesBurnedToday < 1) {
            _numberOfCaloriesBurnedToday = [[newExerciseTextField text] intValue];

        } else {
            _numberOfCaloriesBurnedToday = _numberOfCaloriesBurnedToday + [[newExerciseTextField text] intValue];
        }
        
        
        
        // Fetch the devices from persistent data store
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Exercise"];
        NSMutableArray *devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        NSManagedObject *selectedDevice = [devices objectAtIndex:(devices.count - 1)];
        
        
        
        
        
        
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        
        
        
        NSLog(@"right here");
        
        // Creates a date object representing the current date
//        NSDate *now = [NSDate date];
//        
//        // Creates an object representing the Gregorian calendar
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        
//        // Sets the calendar object with an object representing the time zone specified in System Preferences
//        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
//        
//        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
//        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
//        
//        // Logs the current hour, minute, and second to the console
//        //NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
//        
//        
//        
//        [selectedDevice setValue:now forKey:@"dateLogged"];
        
        [selectedDevice setValue:@(_numberOfCaloriesBurnedToday) forKey:@"numberOfCalories"];
        caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d", _numberOfCaloriesBurnedToday];
        [self saveToParse:_numberOfCaloriesBurnedToday];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        
    }

    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"exerciseCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Exercise"];
    mainArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if (indexPath.row == 0) {
        reversedArray = [[mainArray reverseObjectEnumerator] allObjects];
    }
    

    NSManagedObject *currentDay = [reversedArray objectAtIndex:indexPath.row];
    
    int test;
    
    test = [[currentDay valueForKey:@"numberOfCalories"] intValue];
    
    caloriesBurnedTodayLabel.text = [NSString stringWithFormat:@"%d",test];
    NSDate *testDate = [currentDay valueForKey:@"dateLogged"];

    
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"E MMM d yyyy" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    
    
    [[cell textLabel]setText:[NSString stringWithFormat:@"%d",[[currentDay valueForKey:@"numberOfCalories"] intValue]]];
    [[cell detailTextLabel]setText:[NSString stringWithFormat:@"%@", [formatter stringFromDate:testDate]]];
    return cell;
}


@end
