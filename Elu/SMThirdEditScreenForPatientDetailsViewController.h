//
//  SMThirdEditScreenForPatientDetailsViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/18/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "RMStepsController.h"
#import "AMTagListView.h"


@interface SMThirdEditScreenForPatientDetailsViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;
- (IBAction)addButtonTapped:(id)sender;

@property (strong, nonatomic) NSDictionary *dictionary;

@property (strong, nonatomic) NSMutableArray *allAllergies;
@end
