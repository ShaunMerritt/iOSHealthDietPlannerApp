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

@interface SMSecondEditScreenForPatientDetailsViewController : UIViewController<GKBarGraphDataSource, FPPopoverControllerDelegate> {
    FPPopoverController *popover;
}



@property (weak, nonatomic) IBOutlet GKBarGraph *graphView;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;

- (IBAction)carbs:(id)sender;
- (IBAction)protein:(id)sender;
- (IBAction)fat:(id)sender;

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController;

-(void)selectedTableRow:(NSUInteger)rowNum;

@end
