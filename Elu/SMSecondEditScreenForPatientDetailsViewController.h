//
//  SMSecondEditScreenForPatientDetailsViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/13/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphKit.h"
#import "FPPopoverController.h"
#import "ARCMacros.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "PNChart.h"
#import "XYPieChart.h"
#import "SMFirstEditScreenForPatientDetailsViewController.h"


@interface SMSecondEditScreenForPatientDetailsViewController : UIViewController<GKBarGraphDataSource, FPPopoverControllerDelegate, XYPieChartDelegate, XYPieChartDataSource> {
    FPPopoverController *popover;
}


@property SMFirstEditScreenForPatientDetailsViewController *firstEditScreen;

@property (weak, nonatomic) IBOutlet XYPieChart *pieCharts;

@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@property (weak, nonatomic) IBOutlet UIButton *carbsButton;
@property (weak, nonatomic) IBOutlet UIButton *proteinsButton;
@property (weak, nonatomic) IBOutlet UIButton *fatButton;

@property (strong, nonatomic) PNPieChart *pieChart;


@property int buttonNumberSelected;
@property int valueForCarbs;
@property int valueForProteins;
@property int valueForFats;
@property int totalCaloriesForMaintenece;

@property int numberOfCaloriesForCarbs;
@property int numberOfCaloriesForProteiens;
@property int numberOfCaloriesForFat;

@property (weak, nonatomic) IBOutlet GKBarGraph *graphView;
@property (weak, nonatomic) IBOutlet PNPieChart *pie;


@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;

- (IBAction)carbs:(id)sender;
- (IBAction)protein:(id)sender;
- (IBAction)fat:(id)sender;

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController;

-(void)selectedTableRow:(NSUInteger)rowNum;

- (float) covertToDecimalForMultiplication: (int)percentage;

@end
