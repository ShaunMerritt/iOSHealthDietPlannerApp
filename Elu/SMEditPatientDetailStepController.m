//
//  SMEditPatientDetailStepController.m
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMEditPatientDetailStepController.h"


@interface SMEditPatientDetailStepController () {
    NSString *userName;
}

@end

@implementation SMEditPatientDetailStepController

#pragma mark - Init and Dealloc


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stepsBar.hideCancelButton = YES;
}

#pragma mark - Actions
- (NSArray *)stepViewControllers {
    UIViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep"];
    firstStep.step.title = @"First";
    
    UIViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep2"];
    secondStep.step.title = @"Second";
    
    UIViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep3"];
    thirdStep.step.title = @"Third";
    
    UIViewController *fourthStep = [self.storyboard instantiateViewControllerWithIdentifier:@"SomeStep4"];
    fourthStep.step.title = @"Fourth";
    
    return @[firstStep, secondStep, thirdStep, fourthStep];
}

- (void)finishedAllSteps {
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SMDoctorPatientsTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"doctorsPatients"];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)canceled {
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SMDoctorPatientsTableViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"doctorsPatients"];
    [self.navigationController pushViewController:detailViewController animated:YES];
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

@end
