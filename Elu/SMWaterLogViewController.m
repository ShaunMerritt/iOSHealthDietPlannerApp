//
//  SMWaterLogViewController.m
//  Elu
//
//  Created by Shaun Merritt on 10/3/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

@import CoreData;
#import "SMWaterLogViewController.h"
#import "Water.h"

@interface SMWaterLogViewController ()

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property int cupsOfWater;
@property (strong, nonatomic) NSArray *cupsOfWaterArray;



@end

@implementation SMWaterLogViewController

@synthesize cupsOfWaterObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Fetch the devices from persistent data store
    
   // if (managedObjectContext != nil) {
        
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Water"];
//        NSArray * t = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//        NSLog(@"t: %@", t);
//        NSManagedObject *device = [t objectAtIndex:t.count - 1];
//        NSLog(@"NumberL %@", [device valueForKey:@"numberOfCups"]);
    
    
    
    
    
    
    
    
    
    
//        // Fetch the devices from persistent data store
//        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Water"];
//        self.cupsOfWaterArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//        NSLog(@"cups: %@", _cupsOfWaterArray);
//        
//        if (self.cupsOfWaterArray == nil || [self.cupsOfWaterArray count] == 0) {
//            NSManagedObject *device = [self.cupsOfWaterArray objectAtIndex:_cupsOfWaterArray.count -1 ];
//            NSLog(@"Here: %@",[device valueForKey:@"numberOfCups"]);
//            
//            _cupsOfWater = [[device valueForKey:@"numberOfCups"] intValue];
//            self.amountOfWaterLabel.text = [NSString stringWithFormat:@"%d",_cupsOfWater];
//        } else {
//            
//            NSLog(@"else");
//            self.amountOfWaterLabel.text = @"0";
//            
//
//            
//        }
    
    if ([self coreDataHasEntriesForEntityName:@"Water"] == YES) {
        NSLog(@"Exists");
        // Fetch the devices from persistent data store
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Water"];
        self.cupsOfWaterArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

        NSManagedObject *device = [self.cupsOfWaterArray objectAtIndex:_cupsOfWaterArray.count -1 ];

        _cupsOfWater = [[device valueForKey:@"numberOfCups"] intValue];
        self.amountOfWaterLabel.text = [NSString stringWithFormat:@"%d",_cupsOfWater];
        
    
        NSDate *dateCreated = [device valueForKey:@"dateLogged"];
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
            
            // Create a new managed object
            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Water" inManagedObjectContext:context];
            [newDevice setValue:@(0) forKey:@"numberOfCups"];
            self.amountOfWaterLabel.text = @"0";

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
            _cupsOfWater = 0;
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }


        } else {
            NSLog(@"Same Date");
        }

        
            } else {
        NSLog(@"NONONOO");
                NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
                
                // Create a new managed object
                cupsOfWaterObject = [NSEntityDescription insertNewObjectForEntityForName:@"Water" inManagedObjectContext:managedObjectContext];
                [cupsOfWaterObject setValue:@(0) forKey:@"numberOfCups"];
                
                // Creates a date object representing the current date
                NSDate *now = [NSDate date];
                
                // Creates an object representing the Gregorian calendar
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                
                // Sets the calendar object with an object representing the time zone specified in System Preferences
                [calendar setTimeZone:[NSTimeZone systemTimeZone]];
                
                // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
                NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
                
                // Logs the current hour, minute, and second to the console
                
                
                [cupsOfWaterObject setValue:now forKey:@"dateLogged"];
                
                NSError *error = nil;
                // Save the object to persistent store
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }

        _cupsOfWater = 0;
    }
        
        
        //[cell.detailTextLabel setText:[device valueForKey:@"company"]];
        
    //} else {
        
    //}
//
//    NSManagedObject *device = [t objectAtIndex:t.count - 1];
//    NSLog(@"NumberL %@", [device valueForKey:@"numberOfCups"]);
    
    //NSLog(@"Managed: %@", cupsOfWaterObject);
    
    //_cupsOfWater = 0;
    
    
    
    // Creates a date object representing the current date
    NSDate *now = [NSDate date];
    
    // Creates an object representing the Gregorian calendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Sets the calendar object with an object representing the time zone specified in System Preferences
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
    NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
    
    // Logs the current hour, minute, and second to the console
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)minusOneCupButton:(id)sender {
}

- (IBAction)addOneCupButton:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];

    
    if (_cupsOfWater == 0) {
        _cupsOfWater = 0;
        
       
        [cupsOfWaterObject setValue:@(_cupsOfWater) forKey:@"numberOfCups"];
        
        
        // Creates a date object representing the current date
        NSDate *now = [NSDate date];
        
        // Creates an object representing the Gregorian calendar
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // Sets the calendar object with an object representing the time zone specified in System Preferences
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
        
        // Logs the current hour, minute, and second to the console
        
        
        [cupsOfWaterObject setValue:now forKey:@"dateLogged"];
        _cupsOfWater++;
        self.amountOfWaterLabel.text = [NSString stringWithFormat:@"%d", _cupsOfWater];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

        
    } else {
        _cupsOfWater++;
        
        
        
        
        // Fetch the devices from persistent data store
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Water"];
        NSMutableArray *devices = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        NSManagedObject *selectedDevice = [devices objectAtIndex:(devices.count - 1)];
        
        
        
        
        
        
        
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        
        
        
        NSLog(@"right here");
        
        // Creates a date object representing the current date
        NSDate *now = [NSDate date];
        
        // Creates an object representing the Gregorian calendar
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // Sets the calendar object with an object representing the time zone specified in System Preferences
        [calendar setTimeZone:[NSTimeZone systemTimeZone]];
        
        // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
        NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
        
        // Logs the current hour, minute, and second to the console
        //NSManagedObject *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];

        
        
        [selectedDevice setValue:now forKey:@"dateLogged"];

        [selectedDevice setValue:@(_cupsOfWater) forKey:@"numberOfCups"];
        self.amountOfWaterLabel.text = [NSString stringWithFormat:@"%d", _cupsOfWater];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }


    }
    
    

}

//- (NSManagedObjectModel *)managedObjectModel {
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL= [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSURL *documentsDirectory = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:NO create:NO error:nil];
//    NSURL *storeFile = [documentsDirectory URLByAppendingPathComponent:@"Water.sqlite"];
//    
//    NSError *error;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeFile options:nil error:&error]) {
//        NSLog(@"Error: %@", error);
//    }
//    return _persistentStoreCoordinator;
//}

//- (NSManagedObjectContext *)managedObjectContext {
//    
//    if (_managedObjectModel != nil) {
//        return _managedObjectContext;
//    }
//    if (self.persistentStoreCoordinator != nil) {
//        _managedObjectContext = [[NSManagedObjectContext alloc] init];
//        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
//    }
//    return _managedObjectContext;
//}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
























@end
