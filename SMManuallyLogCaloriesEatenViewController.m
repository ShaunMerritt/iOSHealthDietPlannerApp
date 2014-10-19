//
//  SMManuallyLogCaloriesEatenViewController.m
//  Elu
//
//  Created by Shaun Merritt on 10/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMManuallyLogCaloriesEatenViewController.h"
#import "ManuallyAddedMeal.h"
#import "SMAppDelegate.h"
#import "Patient.h"
#import "SMSaveCaloricInfoToParse.h"

@interface SMManuallyLogCaloriesEatenViewController () {
    
    __weak IBOutlet UIButton *logButton;
    __weak IBOutlet UITextField *_newAmountOfCaloriesTextField;
    int _numberOfCaloriesBurnedToday;
    NSArray *reversedArray;
    SMSaveCaloricInfoToParse *_saveCaloricInfoToParse;
    
}

- (IBAction)addMealButtonClicked:(id)sender;

@end

@implementation SMManuallyLogCaloriesEatenViewController

@synthesize fetchedResultsContoller = _fetchedResultsContoller;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    SMAppDelegate *myid = [[UIApplication sharedApplication] delegate];
    
    //_managedObjectContext = myid.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsContoller] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForManualMealLogging" forIndexPath:indexPath];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    ManuallyAddedMeal *meal = [self.fetchedResultsContoller objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",  meal.numberOfCaloriesForMeal];
    
    
    return cell;
    
}

#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *) fetchedResultsContoller {
    if (_fetchedResultsContoller != nil) {
        return _fetchedResultsContoller;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ManuallyAddedMeal" inManagedObjectContext: [self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    
    //TODO: change sort to meal number
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numberOfCaloriesForMeal"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsContoller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsContoller.delegate = self;
    
    return _fetchedResultsContoller;
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [tableViewInView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tableViewInView endUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = tableViewInView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableViewInView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            NSLog(@"here");
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            ManuallyAddedMeal *changedCourse = [self.fetchedResultsContoller objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", changedCourse.numberOfCaloriesForMeal];
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
            [tableViewInView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableViewInView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) saveTotalCaloriesForDay {
    
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
    
    NSNumber *sum = [NSNumber numberWithFloat:([newVehicle.totalCaloriesEatenToday floatValue] + [_newAmountOfCaloriesTextField.text floatValue])];
    [newVehicle setValue: sum forKey:@"totalCaloriesEatenToday"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesEatenTodayToParse:sum];
    
    NSNumber *sumOfTotalForDay = [NSNumber numberWithFloat:([newVehicle.totalCaloriesForDay floatValue] + [_newAmountOfCaloriesTextField.text floatValue])];
    [newVehicle setValue: sumOfTotalForDay forKey:@"totalCaloriesForDay"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesForDayToParse:sumOfTotalForDay];

    
    [self.managedObjectContext save:nil];
    

    
}

- (NSDate *)calculateCurrentDateWithTimeSetToZero {
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    return dateOnly;
    
}

- (IBAction)addMealButtonClicked:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *mealObject = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"ManuallyAddedMeal"
                                   inManagedObjectContext:context];
    
    
    [mealObject setValue:@([[_newAmountOfCaloriesTextField text] intValue]) forKey:@"numberOfCaloriesForMeal"];
    
    [self saveTotalCaloriesForDay];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    

    
}
@end
