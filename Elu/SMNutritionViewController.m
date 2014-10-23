                                //
//  SMNutritionViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMNutritionViewController.h"
#import "YummlyModel.h"
#import "YummlyGetModel.h"
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
#import "SMAppDelegate.h"



#define UIAppDelegate \ [(SMAppDelegate *)[[UIApplication sharedApplication] delegate];
@interface SMNutritionViewController () <YLLongTapShareDelegate, DCPathButtonDelegate>

@end

@implementation SMNutritionViewController {
    NSArray *returnedFoods;
    NSArray *returnedRecipe;
    NSDictionary *dict;
    NSDictionary *dicts;
    NSDictionary *itemsReturned;
    NSDictionary *infoFromUPCScanReturned;
    NSString *doctorChosenDietURL;
}

- (id) init {
    
    NSLog(@"herrr");
    
    if ([self isViewLoaded]) {
        self.view=nil;
        [self viewDidLoad];
    }
    
    [self viewDidLoad];
    
    return self;
    
    
    
    
}

- (void)buttonPressed:(id)sender
{
    
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

- (void) loadGraphs {
    
    //For LineChart
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    lineChart.delegate = self;
    [lineChart setXLabels:[self generateDatesForXLabels]];
    lineChart.yLabelFormat = @"%1.1f";
    lineChart.backgroundColor = [UIColor clearColor];
    lineChart.showCoordinateAxis = YES;


    
    // Line Chart No.1
    NSArray * data01Array = [self generateCaloriesForYLabels];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.inflexionPointStyle = PNLineChartPointStyleCycle;
    data01.inflexionPointWidth = (CGFloat)5;
    data01.color = PNDeepGrey;
    data01.lineWidth = (CGFloat)3;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    
    lineChart.chartData = @[data01];
    
    [self.view addSubview:lineChart];

    [lineChart strokeChart];

}



- (NSArray *) generateCaloriesForYLabels {
    NSMutableArray *datesArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Patient" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    NSMutableArray *arrayOfDataForChart = [[NSMutableArray alloc] init];
    for (int i = 0; i < [results count]; i++) {
        Patient *newVehicle = [results objectAtIndex:i];
        [arrayOfDataForChart addObject: newVehicle.totalCaloriesForDay];
        NSLog(@"data: %@", newVehicle.totalCaloriesForDay);

    }
    
    if (arrayOfDataForChart.count < 8) {
        for (int i = [arrayOfDataForChart count]; i < 7; i++) {
            [arrayOfDataForChart addObject: @0];
        }
    }
    
    NSArray *arrayOfDataReversed = [[arrayOfDataForChart reverseObjectEnumerator] allObjects];
    NSLog(@"Dates Array: %@", datesArray);
    return arrayOfDataReversed;

}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}

- (NSArray *) generateDatesForXLabels {
    
    NSMutableArray *datesArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i++) {
        if (i == 0) {
            [datesArray addObject:@"Today"];
            NSLog(@"Dates Array: %@", datesArray);

        } else {
            NSDate *currentDate = [NSDate date];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:-i];
            NSDate *dateToConvetToString = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
            //NSLog(@"\ncurrentDate: %@\nseven days ago: %@", currentDate, dateToConvetToString);
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd"];
            NSString *dateString = [dateFormatter stringFromDate:dateToConvetToString];
            [datesArray addObject:dateString];
        }
    }
    
    
    NSArray *datesReversed = [[datesArray reverseObjectEnumerator] allObjects];
    NSLog(@"Dates Array: %@", datesArray);
    return datesReversed;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"HEREEEE");
    
    [self loadGraphs];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    // Do any additional setup after loading the view, typically from a nib.
//    UIImage *buttonImage = [UIImage imageNamed:@"hood.png"];
//    UIImage *highlightImage = [UIImage imageNamed:@"hood.png"];
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
//    if (heightDifference < 0)
//        button.center = self.tabBarController.tabBar.center;
//    else
//    {
//        CGPoint center = self.tabBarController.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
//    }
//    //[button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//    [self.tabBarController.view addSubview:button];
//    
//    
//    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
//    overlay.dataSource = self;
//    overlay.delegate = self;
//    
//    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
//    
//    
//    
//    
//    
//    
//    [button addGestureRecognizer:_longPressRecognizer];

    
//    YLLongTapShareView *test = [[YLLongTapShareView alloc] initWithFrame:CGRectMake(80.0, 300.0, 300, 300)];
//    
//    [self.view addSubview:test];
//    test.backgroundColor = [UIColor blackColor];
//    [test addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"facebook"] andTitle:@"Facebook"]];
//    
//    
//    [button addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"facebook"] andTitle:@"Facebook"]];
//    [self.view addSubview:button];
//    
//    [self testMethod];

    
    //[self addCenterButtonWithImage:[UIImage imageNamed:@"hood.png"] highlightImage:[UIImage imageNamed:@"hood-selected.png"] target:self action:@selector(buttonPressed:)];
    
//    [self.view addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"facebook"] andTitle:@"Facebook"]];
//    [self.longTapShareButton addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"pinterest"] andTitle:@"Pinterest"]];
//    [self.longTapShareButton addShareItem:[YLShareItem itemWithIcon:[UIImage imageNamed:@"instagram"] andTitle:@"Instagram"]];
    
    // FIXME: Remember to add exception if there is no logged in user.
    
    // Find total caloreis needed perday for the logged in user.
//    PFQuery *queryForDiet = [PFQuery queryWithClassName:@"CaloriesPerDay"];
//    [queryForDiet whereKey:@"user" equalTo:PFUser.currentUser];
//    
//    [queryForDiet findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            // Do something with the found objects
//            for (PFObject *object in objects) {
//                NSLog(@"object: %@", object);
//                //log the objects that we got back to the NSLOG
//                NSString *reccomendedDailyCalories = [object valueForKey:@"totalDailyCalories"];
//                
//                
//                
//                [[PFUser currentUser] setObject:reccomendedDailyCalories forKey:@"RecommendedCaloriesForMaintenece"];
//                
//                //Save all data to Parse
//                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (!error) {
//                        //[self dismissModalViewControllerAnimated:YES];
//                    }
//                }];
//                
//                
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//    
//    //SMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    PFUser *currentUser = [PFUser currentUser];
//    if (currentUser) {
//        NSString *doctor = [[PFUser currentUser] objectForKey:@"isDoctor"];
//
//        if ([doctor isEqualToString:@"no"]) {
//            NSLog(@"Current User %@", currentUser.username);
//            NSString *relatedDoctor = [[PFUser currentUser] objectForKey:@"doctorIdentifier"];
//            
//            PFQuery *query = [PFUser query];
//            [query whereKey:@"objectId" equalTo:relatedDoctor];
//            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                if (error) {
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//                else {
//                    self.allDoctors = objects;
//                    [self.tableView reloadData];
//                }
//            }];
//
//        }
//        
//        
//    }
//    else {
//        [self performSegueWithIdentifier:@"showLogin" sender:self];
//    }
//    
//    self.currentUser = [PFUser currentUser];
//
//
    
    
    DCPathButton *centerButton = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                          hilightedImage:[UIImage imageNamed:@"chooser-button-tab-highlighted"]];
    [self.tabBarController.view addSubview:centerButton];
    
    centerButton.delegate = self;
    
    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-button-tab"]];
    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-button-tab"]];
    DCPathItemButton *itemButton_3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-button-tab"]];
    DCPathItemButton *itemButton_4 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                           highlightedImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-button-tab"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-button-tab"]];
    
    [centerButton addPathItem:@[itemButton_1, itemButton_2, itemButton_3, itemButton_4]];

    NSLog(@"added");
    
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

#pragma mark - HERE

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            msg = @"Facebook Selected";
            [self testMethod];

            break;
        case 1:
            //msg = @"Twitter Selected";
            
            [self showLog];
            
            break;
        case 2:
            msg = @"Google Plus Selected";
            break;
            
        default:
            break;
    }
    
//    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
    
}

- (void) showLog {
    
    SMLogFoodTableViewController *secondViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"logFood"];
    [self.navigationController pushViewController:secondViewController animated:YES];

}

- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBarController.tabBar.frame.size.height;
    if (heightDifference < 0) {
        button.center = self.tabBarController.tabBar.center;
    } else {
        CGPoint center = self.tabBarController.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    NSLog(@"Im e");
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [self.allDoctors count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"CellNow";
//    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    PFUser *user                    = [self.allDoctors objectAtIndex:indexPath.row];
//    cell.textLabel.text             = user.username;
//    
//    return cell;
//    
//}
//
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    UITableViewCell *cell        = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType           = UITableViewCellAccessoryCheckmark;
//
//    PFRelation *doctorsRelations = [self.currentUser relationforKey:@"doctorsRelation"];
//    PFUser *user                 = [self.allDoctors objectAtIndex:indexPath.row];
//    [doctorsRelations addObject:user];
//    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error){
//            NSLog(@"Error %@, %@", error, [error userInfo]);
//        }
//    }];
//    
//    /*
//    UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"foodLikedViewController"];
//    vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:vcs animated:YES completion:nil];
//    */
//     
//    /*
//    UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"firstTimePatientSignedIn"];
//    vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:vcs animated:YES completion:nil];
//    
//    */
//}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    //PFUser *currentUser = [PFUser currentUser];
    NSLog(@"Signed Out");
    ((SMAppDelegate *)[UIApplication sharedApplication].delegate).signedOut = YES;

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"loginViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];


}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setIsLoggedOut: YES];

        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
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

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSDate *)calculateCurrentDateWithTimeSetToZero {
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    return dateOnly;
    
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
@end







