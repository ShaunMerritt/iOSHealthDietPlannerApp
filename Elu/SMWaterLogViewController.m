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
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Water"];
//    NSArray * t = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
//    NSLog(@"t: %@", t);
//    
//    NSManagedObject *device = [t objectAtIndex:t.count - 1];
//    NSLog(@"NumberL %@", [device valueForKey:@"numberOfCups"]);
    _cupsOfWater = 0;
    
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

- (IBAction)minusOneCupButton:(id)sender {
}

- (IBAction)addOneCupButton:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];

    
    if (_cupsOfWater == 0) {
        _cupsOfWater = 0;
        
        // Create a new managed object
        cupsOfWaterObject = [NSEntityDescription insertNewObjectForEntityForName:@"Water" inManagedObjectContext:context];
        [cupsOfWaterObject setValue:@(_cupsOfWater) forKey:@"numberOfCups"];
        _cupsOfWater++;
        
    } else {
        [cupsOfWaterObject setValue:@(_cupsOfWater) forKey:@"numberOfCups"];
        _cupsOfWater++;
    }
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
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
