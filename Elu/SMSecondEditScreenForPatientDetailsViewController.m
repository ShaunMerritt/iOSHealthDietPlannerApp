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


@interface SMSecondEditScreenForPatientDetailsViewController () {
    NSArray * arrayOfAllPercentages;
}

@property (nonatomic, assign) BOOL green;

@end

@implementation SMSecondEditScreenForPatientDetailsViewController
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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
//    self.data = @[@65, @10, @40, @90, @50, @75];
//    self.labels = @[@"US", @"UK", @"DE", @"PL", @"CN", @"JP"];
//    
//    //    self.graphView.barWidth = 22;
//    //    self.graphView.barHeight = 140;
//    //    self.graphView.marginBar = 25;
//    //    self.graphView.animationDuration = 2.0;
//    
//    self.graphView.dataSource = self;
//    
//    [self.graphView draw];
//    
//    self.green = YES;
    
    //50, 20, 30
    self.valueForCarbs = 50;
    self.valueForProteins = 20;
    self.valueForFats = 30;
    
    arrayOfAllPercentages = [[NSArray alloc] initWithObjects:@"10%", @"25%", @"30%", @"35%", @"40%", @"45%", @"50%", @"55%", @"60%", @"65%", @"70%", @"75%", @"80%", @"85%", @"90%", @"95%", @"100%", nil];
    
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNFreshGreen],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNiOSGreenColor description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNMauve description:@"GOOL I/O"],
                       ];
    
    
    
    pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:14.0];
    pieChart.descriptionTextShadowColor = [UIColor clearColor];
    [pieChart strokeChart];
    
    
    [self.view addSubview:pieChart];
    
    //viewController.title = @"Pie Chart";


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
            [self drawPieChart];
            break;
        case 2:
            self.proteinsButton.titleLabel.text = [NSString stringWithFormat:@"%@", [arrayOfAllPercentages objectAtIndex:rowNum]];
            [self removePercentAndConvertToInt:self.proteinsButton.titleLabel.text];
            self.valueForProteins = [self removePercentAndConvertToInt:self.carbsButton.titleLabel.text];
            [self drawPieChart];
            break;
        default:
            self.fatButton.titleLabel.text = [NSString stringWithFormat:@"%@", [arrayOfAllPercentages objectAtIndex:rowNum]];
            [self removePercentAndConvertToInt:self.fatButton.titleLabel.text];
            self.valueForFats = [self removePercentAndConvertToInt:self.carbsButton.titleLabel.text];
            [self drawPieChart];
            break;
    }
    
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
    return value;
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
@end
