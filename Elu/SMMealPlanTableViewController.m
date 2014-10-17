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

@interface SMMealPlanTableViewController () {
    NSDate *currentDate;
    NSDate *datePicked;
    NSDate *_dateChosenByUser;
}

@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;




@end

@implementation SMMealPlanTableViewController
@synthesize allMeals;
@synthesize fetchedResultsContoller = _fetchedResultsContoller;

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
