//
//  SMDoctorPatientsTableViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLoginViewController.h"

@interface SMDoctorPatientsTableViewController : UITableViewController

@property (nonatomic, strong) SMAppDelegate         *appDelegate;
@property (nonatomic, strong) NSArray               *allUsers;
@property (nonatomic, strong) PFRelation            *doctorsRelation;
@property (nonatomic, strong) NSArray               *patients;
@property (nonatomic, strong) SMLoginViewController *logInViewController;


@end
