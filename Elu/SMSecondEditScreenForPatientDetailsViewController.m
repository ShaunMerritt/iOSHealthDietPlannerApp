//
//  SMSecondEditScreenForPatientDetailsViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/13/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMSecondEditScreenForPatientDetailsViewController.h"
#import "RMStepsController.h"
#import "ASValueTrackingSlider.h"
#import "SMAppDelegate.h"
#import "SMSecondEditPatientTableViewController.h"
#import "SMFirstEditScreenForPatientDetailsViewController.h"
#import "SMAppDelegate.h"



@interface SMSecondEditScreenForPatientDetailsViewController () {
    NSArray * arrayOfAllPercentages;
}

@property (nonatomic, assign) BOOL green;

@end

@implementation SMSecondEditScreenForPatientDetailsViewController
@synthesize firstEditScreen = _firstEditScreen;
@synthesize pieCharts = _pieCharts;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;
@synthesize pieChart;

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
    
    SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.totalCaloriesForMaintenece = appDelegate.totalCaloriesForMaintenece;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
    NSLog(@"User Name %@", self.firstEditScreen.userName);
    
    //50, 20, 30
    self.valueForCarbs = 35;
    self.valueForProteins = 40;
    self.valueForFats = 25;
    
    arrayOfAllPercentages = [[NSArray alloc] initWithObjects:@"10%", @"25%", @"30%", @"35%", @"40%", @"45%", @"50%", @"55%", @"60%", @"65%", @"70%", @"75%", @"80%", @"85%", @"90%", @"95%", @"100%", nil];
    
    
    
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNFreshGreen],
//                       [PNPieChartDataItem dataItemWithValue:20 color:PNiOSGreenColor description:@"WWDC"],
//                       [PNPieChartDataItem dataItemWithValue:40 color:PNMauve description:@"GOOL I/O"],
//                       ];
//    
//    
//    
//    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
//    pieChart.descriptionTextColor = [UIColor whiteColor];
//    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
//    pieChart.descriptionTextShadowColor = [UIColor clearColor];
//    [pieChart strokeChart];
//    
//    
//    [self.view addSubview:pieChart];
//    
    //viewController.title = @"Pie Chart";
    
    
    
    
    
    
    self.slices = [NSMutableArray arrayWithCapacity:3];
    [_slices addObject:[NSNumber numberWithInteger:self.valueForCarbs]];
    [_slices addObject:[NSNumber numberWithInteger:self.valueForProteins]];
    [_slices addObject:[NSNumber numberWithInteger:self.valueForFats]];
    
    
    [self.pieCharts setDelegate:self];
    [self.pieCharts setDataSource:self];
    [self.pieCharts setPieCenter:CGPointMake(self.pieCharts.center.x, self.pieCharts.center.y)];
    [self.pieCharts setShowPercentage:NO];
    [self.pieCharts setLabelColor:[UIColor blackColor]];
    
    
    self.sliceColors = [NSArray arrayWithObjects:
                       [UIColor gk_pumpkinColor],
                       [UIColor gk_amethystColor],
                       [UIColor gk_emerlandColor], nil];

    
    


}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieCharts reloadData];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//#pragma mark - GKBarGraphDataSource
//
//- (NSInteger)numberOfBars {
//    return [self.data count];
//}
//
//- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
//    return [self.data objectAtIndex:index];
//}
//
//- (UIColor *)colorForBarAtIndex:(NSInteger)index {
//    id colors = @[[UIColor gk_turquoiseColor],
//                  [UIColor gk_peterRiverColor],
//                  [UIColor gk_alizarinColor],
//                  [UIColor gk_amethystColor],
//                  [UIColor gk_emerlandColor],
//                  [UIColor gk_sunflowerColor]
//                  ];
//    return [colors objectAtIndex:index];
//}
//
////- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
////    return [UIColor redColor];
////}
//
//- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
//    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
//    percentage = (percentage / 100);
//    return (self.graphView.animationDuration * percentage);
//}
//
//- (NSString *)titleForBarAtIndex:(NSInteger)index {
//    return [self.labels objectAtIndex:index];
//}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    NSLog(@"Ri");
    //[visiblePopoverController dismissPopoverAnimated:YES];
}

-(void)selectedTableRow:(NSUInteger)rowNum
{
    NSLog(@"SELECTED ROW %lu",(unsigned long)rowNum);
    [popover dismissPopoverAnimated:YES];
    
    switch (self.buttonNumberSelected) {
        case 1:
            self.carbsButton.titleLabel.text = [NSString stringWithFormat:@"%@", [arrayOfAllPercentages objectAtIndex:rowNum]];
            self.valueForCarbs = [self removePercentAndConvertToInt:self.carbsButton.titleLabel.text];
            NSLog(@"Car %i", _valueForCarbs);
            self.numberOfCaloriesForCarbs = [self covertToDecimalForMultiplication: self.valueForCarbs] * self.totalCaloriesForMaintenece;
            [_slices replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:_valueForCarbs]];
            NSLog(@"%@", _slices);
            break;
        case 2:
            self.proteinsButton.titleLabel.text = [NSString stringWithFormat:@"%@", [arrayOfAllPercentages objectAtIndex:rowNum]];
            //[self removePercentAndConvertToInt:self.proteinsButton.titleLabel.text];
            self.valueForProteins = [self removePercentAndConvertToInt:self.proteinsButton.titleLabel.text];
            NSLog(@"pro %i", _valueForProteins);
            self.numberOfCaloriesForProteiens = [self covertToDecimalForMultiplication: self.valueForProteins] * self.totalCaloriesForMaintenece;
            [_slices replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:_valueForProteins]];
            NSLog(@"%@", _slices);
            
            break;
        default:
            self.fatButton.titleLabel.text = [NSString stringWithFormat:@"%@", [arrayOfAllPercentages objectAtIndex:rowNum]];
            //[self removePercentAndConvertToInt:self.fatButton.titleLabel.text];
            self.valueForFats = [self removePercentAndConvertToInt:self.fatButton.titleLabel.text];
            NSLog(@"FAt %i", _valueForFats);
            self.numberOfCaloriesForFat = [self covertToDecimalForMultiplication: self.valueForFats] * self.totalCaloriesForMaintenece;
            [_slices replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:_valueForFats]];
            NSLog(@"%@", _slices);
            break;
    }
    
    [self reloadTheChart];
    
}

- (void) drawPieChart {
    
    [pieChart removeFromSuperview];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:self.valueForCarbs color:PNFreshGreen description:[NSString stringWithFormat:@"Carbs: %d",self.valueForCarbs]],
                       [PNPieChartDataItem dataItemWithValue:self.valueForProteins color:PNiOSGreenColor description:[NSString stringWithFormat:@"Protein: %d",self.valueForProteins]],
                       [PNPieChartDataItem dataItemWithValue:self.valueForFats color:PNMauve description:[NSString stringWithFormat:@"Fats: %d",self.valueForFats]],
                       ];

    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [pieChart strokeChart];
    
    
    [self.view addSubview:pieChart];
    
}

- (IBAction)carbs:(id)sender {
    
    //the view controller you want to present as popover
    SMSecondEditPatientTableViewController *controller = [[SMSecondEditPatientTableViewController alloc] init];
    controller.delegate = self;

    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:sender];
    
    self.buttonNumberSelected = 1;

    
}

- (int) removePercentAndConvertToInt: (NSString *)percentage {
    [percentage stringByReplacingOccurrencesOfString:@"%" withString:@""];
    int value = [percentage intValue];
    NSLog(@"Per: %@", percentage);
    NSLog(@"Val: %d", value);
    return value;
}

- (float) covertToDecimalForMultiplication: (int)percentage {
    
    NSLog(@"pee: %i", percentage);
    float te = percentage;
    float percentageValue = te/100;
    NSLog(@"percent val = %f", percentageValue);
    return percentageValue;
    
}

- (IBAction)protein:(id)sender {
    
    //the view controller you want to present as popover
    SMSecondEditPatientTableViewController *controller = [[SMSecondEditPatientTableViewController alloc] init];
    controller.delegate = self;
    
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:sender];
    
    self.buttonNumberSelected = 2;
    
}

- (IBAction)fat:(id)sender {
    
    //the view controller you want to present as popover
    SMSecondEditPatientTableViewController *controller = [[SMSecondEditPatientTableViewController alloc] init];
    controller.delegate = self;
    
    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:sender];
    
    self.buttonNumberSelected = 3;
    
}

- (void) reloadTheChart
{
    [self.pieCharts reloadData];
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
}


#pragma mark - Actions
- (IBAction)nextStepTapped:(id)sender {
    
    SMAppDelegate *appDelegate = (SMAppDelegate *)[[UIApplication sharedApplication] delegate];

    // Find total caloreis needed perday for the logged in user.
    
    
    
    // Query for users with the same username as the one passed in from the tablecell
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:appDelegate.userName]; // the editing patient by username
    NSArray *currentPatient = [query findObjects];
    NSLog(@"Current patient is: %@", currentPatient);
    
    PFQuery *queryForDiet = [PFQuery queryWithClassName:@"CaloriesPerDay"];
    [queryForDiet whereKey:@"user" equalTo:[currentPatient objectAtIndex:0]];
    
    [queryForDiet findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object: %@", object);
                //log the objects that we got back to the NSLOG
                
                
                NSLog(@"carbs %d", self.numberOfCaloriesForCarbs);
                

                    NSLog(@"Got to here");
                    object[@"caloriesDedicatedToCarbs"] = [NSString stringWithFormat:@"%d", self.numberOfCaloriesForCarbs];
                    object[@"caloriesDedicatedToProteins"] = [NSString stringWithFormat:@"%d", self.numberOfCaloriesForProteiens];
                    object[@"caloriesDedicatedToFats"] = [NSString stringWithFormat:@"%d", self.numberOfCaloriesForFat];
                    
                    [object saveInBackground];
                
                
                
                //Save all data to Parse
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        //[self dismissModalViewControllerAnimated:YES];
                    }
                }];
                
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    [self.stepsController showNextStep];
    
}

- (IBAction)previousStepTapped:(id)sender {
    [self.stepsController showPreviousStep];
}





@end
