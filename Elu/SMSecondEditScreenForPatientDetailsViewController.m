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


@interface SMSecondEditScreenForPatientDetailsViewController ()

@property (nonatomic, assign) BOOL green;

@end

@implementation SMSecondEditScreenForPatientDetailsViewController

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
    
    self.data = @[@65, @10, @40, @90, @50, @75];
    self.labels = @[@"US", @"UK", @"DE", @"PL", @"CN", @"JP"];
    
    //    self.graphView.barWidth = 22;
    //    self.graphView.barHeight = 140;
    //    self.graphView.marginBar = 25;
    //    self.graphView.animationDuration = 2.0;
    
    self.graphView.dataSource = self;
    
    [self.graphView draw];
    
    self.green = YES;

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

#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    return [self.data count];
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_amethystColor],
                  [UIColor gk_emerlandColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

//- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
//    return [UIColor redColor];
//}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (self.graphView.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

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
}


- (IBAction)carbs:(id)sender {
    
    //the view controller you want to present as popover
    SMSecondEditPatientTableViewController *controller = [[SMSecondEditPatientTableViewController alloc] init];
    controller.delegate = self;

    //our popover
    popover = [[FPPopoverController alloc] initWithViewController:controller];
    
    //the popover will be presented from the okButton view
    [popover presentPopoverFromView:sender];

    
}

- (IBAction)protein:(id)sender {
}

- (IBAction)fat:(id)sender {
}
@end
