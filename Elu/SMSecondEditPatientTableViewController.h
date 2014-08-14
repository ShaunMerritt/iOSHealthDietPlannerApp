//
//  SMSecondEditPatientTableViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/13/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMSecondEditScreenForPatientDetailsViewController;

@interface SMSecondEditPatientTableViewController : UITableViewController
@property(nonatomic,assign) SMSecondEditScreenForPatientDetailsViewController *delegate;

@property NSArray *array;

@end
