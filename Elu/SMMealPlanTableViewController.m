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


@interface SMMealPlanTableViewController () <VENSeparatorTableViewCellProviderDelegate> {
    NSDate *currentDate;
    NSCalendar *calendar;
    NSDateComponents *components;
    NSDate *selectedDate;
    BOOL *dateYes;
    int mealAhead;
    long numberOfDays;
    long number;
    NSDate *datePicked;
    NSDate *_dateChosenByUser;
}

@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;

@property (nonatomic, strong) VENSeparatorTableViewCellProvider *separatorProvider;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;


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
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    [self.datepicker fillCurrentWeek];
    [self.datepicker selectDateAtIndex:0];
    
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 2;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    NSLog(@"nextDate: %@ ...", nextDate);
    
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorProvider = [[VENSeparatorTableViewCellProvider alloc] initWithStrokeColor:[UIColor grayColor]
                                                                                  fillColor:[UIColor lightGrayColor]
                                                                                   delegate:self];
    
    // Create array from all meals in the array of meals from plist:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
    allMeals = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath]mutableCopy];
    NSLog(@"All Meals at index 0: %@", [allMeals objectAtIndex:0]);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary = [allMeals objectAtIndex:0];
    NSLog(@"Here is my dictionary: %@", dictionary);
    
    NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
    NSLog(@"The total time is: %@ seconds", [dictionary objectForKey:@"Total Time In Seconds"]);
    
    NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];
    
//    int x;
//    
//    while (x < 6) {
//        
//        if (x < 4) {
//            x++;
//            NSCalendar *cal = [NSCalendar currentCalendar];
//            NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:mealDate];
//            NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:selectedDate];
//            NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
//            
//            NSLog(@"comparison: %ld", comparison);
//            
//            if (comparison == NSOrderedSame)
//            {
//                NSLog(@"SAME");
//            }
//            
//
//        } else if (x < 7) {
//            
//            if (x== 4) {
//                [components setDay:1];
//                currentDate = [calendar dateByAddingComponents:components
//                                                        toDate:currentDate
//                                                       options:0];
//            }
//            
//            NSCalendar *cal = [NSCalendar currentCalendar];
//            NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:mealDate];
//            NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:selectedDate];
//            NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
//            
//            NSLog(@"comparison: %ld", comparison);
//            
//            x++;
//            
//            if (comparison == NSOrderedSame)
//            {
//                NSLog(@"SAME");
//            }
//
//        }
//        
//        
//        
//        
//    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:mealDate];
    NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:selectedDate];
    NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
    
    NSLog(@"comparison: %ld", comparison);
    
    if (comparison == NSOrderedSame)
    {
        NSLog(@"SAME");
    }

    
    


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


- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}

- (long)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendarss = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componentss = [calendarss components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [componentss day]+1;
}

- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    
    
    NSLog(@"Current date: %@", day.day);
    
    
    currentDate = [NSDate date];
    
    numberOfDays = [self daysBetween:selectedDate and:day.date];
    
    number = (numberOfDays * 9 / 4) - 1;
    
    

    
    
    
    NSLog(@"Did select day %@",day.day);
    
    if (_dayNumber > 0) {
        _dayNumber --;
    } else {
        self.dayNumber ++;
    }
    
    selectedDate = day.date;
    
    
    
    [self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
        
    NSLog(@"Will select day %@",day.day);
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
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    
//    [components setDay:1];
//    currentDate = [calendar dateByAddingComponents:components
//                                            toDate:currentDate
//                                           options:0];
    
//    NSDate *start = [NSDate date];
//    NSDate *end = selectedDate;
//    NSCalendarUnit units = NSDayCalendarUnit;
//    components = [calendar components:units
//                                               fromDate:start
//                                                 toDate:end
//                                                options:0];
//    NSLog(@"It has been %ld weeks since January 1st, 2001",
//          [components week]);
    
//    NSDate *start = [NSDate dateWithTimeInterval:0 sinceDate:currentDate];
//    
//    NSCalendar *calendaar = [[NSCalendar alloc]
//                            initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *componentst = [[NSDateComponents alloc] init];
//    [componentst setDay:1];
//    NSDate *end = [calendaar dateByAddingComponents:componentst
//                                                        toDate:start
//                                                       options:0];
//    
//    //NSDate *end = [NSDate date];
//    NSCalendar *calendars = [NSCalendar currentCalendar];
//    NSCalendarUnit units = NSDayCalendarUnit;
//    NSDateComponents *componentss = [calendars components:units
//                                               fromDate:start
//                                                 toDate:end
//                                                options:0];
//    NSLog(@"It has been %ld weeks since January 1st, 2001",
//          [componentss day]);
//    
//    int x;
    
    //    while (dateYes == NO) {
//        NSLog(@"Here");
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        dictionary = [allMeals objectAtIndex:_test];
//        NSLog(@"Here is my dictionary: %@", dictionary);
//        
//        NSLog(@"My meal is here");
//        
//        NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];
//        NSLog(@"meal date: %@", mealDate);
//        NSLog(@"selected date: %@", mealDate);
//        if ([mealDate isEqualToDate:selectedDate]) {
//            NSLog(@"HOOra!");
//        }
//        x ++;
//        if (x>6) {
//            dateYes = YES;
//        }
//    }
//    
//    if (_test < 4) {
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//        dictionary = [allMeals objectAtIndex:_test];
//        NSLog(@"Here is my dictionary: %@", dictionary);
//        
//        
//        NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];
//        
//        NSCalendar *cal = [NSCalendar currentCalendar];
//        NSDateComponents *date1Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:mealDate];
//        NSDateComponents *date2Components = [cal components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:selectedDate];
//        NSComparisonResult comparison = [[cal dateFromComponents:date1Components] compare:[cal dateFromComponents:date2Components]];
//        
//        NSLog(@"comparison: %ld", comparison);
//        
//        if (comparison == NSOrderedSame)
//        {
//            NSLog(@"SAME");
//        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//        if (number < 4) {
//            dictionary = [allMeals objectAtIndex:number];
//            number ++;
//        } else if (number > 3 && number < 7) {
//            dictionary = [allMeals objectAtIndex:number];
//            number ++;
//        }
//        
//        
//        
//        UIImageView *imageHolder = (UIImageView *)[cell viewWithTag:1];
//        
//        UILabel *nameOfFood = (UILabel *)[cell viewWithTag:2];
//        nameOfFood.text = [dictionary objectForKey:@"Recipe Name"];
//        
//        NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
//        
//        NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"Hosted Medium URL"]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
//        
//        __weak UITableViewCell *weakCell = cell;
//        
//        [imageHolder setImageWithURLRequest:request
//                           placeholderImage:placeholderImage
//                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                        
//                                        weakCell.backgroundView = [[UIImageView alloc] initWithImage:image];
//                                        
//                                        [weakCell setNeedsLayout];
//                                        
//                                    } failure:nil];
//        [self.separatorProvider applySeparatorsToCell:cell atIndexPath:indexPath inTableView:tableView cellHeight:0];
//    
//
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
 /*else {
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [allMeals objectAtIndex:_test];
        NSLog(@"Here is my dictionary: %@", dictionary);

    
    
        UIImageView *imageHolder = (UIImageView *)[cell viewWithTag:1];
        
        UILabel *nameOfFood = (UILabel *)[cell viewWithTag:2];
        nameOfFood.text = [dictionary objectForKey:@"Recipe Name"];
        
        NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
        
        NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"Hosted Medium URL"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UITableViewCell *weakCell = cell;
        
        [imageHolder setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.backgroundView = [[UIImageView alloc] initWithImage:image];
                                           
                                           [weakCell setNeedsLayout];
                                           
                                       } failure:nil];
        [self.separatorProvider applySeparatorsToCell:cell atIndexPath:indexPath inTableView:tableView cellHeight:0];
    

    //_test ++;
  
  */
    
    Meal *meal = [self.fetchedResultsContoller objectAtIndexPath:indexPath];
    cell.textLabel.text = meal.recipeName;

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row % 7 == 4 ||indexPath.row % 5 == 2) {
//        return 44;
//    }
//    else {
        return 120;
    //}

    
}

#pragma mark - VENTableViewSeparatorProviderDelegate methods

- (BOOL)isCellJaggedAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row % 7 == 4 ||indexPath.row % 5 == 2) {
//        return YES;
//    }
//    else {
        return NO;
    //}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *) fetchedResultsContoller {
    if (_fetchedResultsContoller != nil) {
        return _fetchedResultsContoller;
    }
    
    
    
    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    
//    // Create a new managed object
//    NSManagedObject *cupsOfWaterObject = [NSEntityDescription insertNewObjectForEntityForName:@"Water" inManagedObjectContext:managedObjectContext];
//    [cupsOfWaterObject setValue:@(0) forKey:@"numberOfCups"];
//    
//    // Creates a date object representing the current date
//    NSDate *now = [NSDate date];
//    
//    // Creates an object representing the Gregorian calendar
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    
//    // Sets the calendar object with an object representing the time zone specified in System Preferences
//    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
//    
//    // Calls the components:fromDate: method on the calendar object, passing in the date object created in line 2. This call returns an object containing the hour, minute, and second components of the date object
//    NSDateComponents *dc = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:now];
//    
//    // Logs the current hour, minute, and second to the console
//    
//    
//    [cupsOfWaterObject setValue:now forKey:@"dateLogged"];
//    
//    NSError *error = nil;
//    // Save the object to persistent store
//    if (![managedObjectContext save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//    }

    
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meal" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateForMeal == %@", _dateChosenByUser];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mealNumber"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsContoller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsContoller;
}


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"showRecipeDetail"]) {
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     SMRecipeDetailViewController *destViewController = segue.destinationViewController;
//         NSLog(@"HEEEERE: %@", [allMeals objectAtIndex:indexPath.row]);
//         
//         
//         
//         
//     destViewController.recipeName = [allMeals objectAtIndex:indexPath.row];
         
         NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
         dictionary = [allMeals objectAtIndex:indexPath.row];
//         NSLog(@"Here is my dictionary: %@", dictionary);
//         
//         NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
//         NSLog(@"The total time is: %@ seconds", [dictionary objectForKey:@"Total Time In Seconds"]);
//         
//         NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];
         destViewController.recipeName = dictionary;

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
    
    NSDateComponents* componentsForDatePicker = [calendarForDatePicker components:flags fromDate:self.datepicker.selectedDate];
    
    NSDate* dateOnly = [calendarForDatePicker dateFromComponents:componentsForDatePicker];
    
    NSLog(@"Date only: %@", dateOnly);
    
    NSLog(@"Date: %@", self.datepicker.selectedDate);
    
    
}

@end
