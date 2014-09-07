//
//  SMFirstTimePateientViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/20/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOMSMorphingLabel.h"
#import "SMLikeFoodViewController.h"

@interface SMFirstTimePateientViewController : UIViewController

@property (nonatomic, strong) NSArray       *allDoctors;
@property (nonatomic, strong) PFUser        *currentUser;
@property (nonatomic, strong) NSMutableString *growingIntro;
@property (nonatomic, strong) TOMSMorphingLabel *label;

@property (nonatomic, strong) NSString *doctorsName;
@property (nonatomic, strong) PFUser        *doctor;
- (IBAction)yesButton:(id)sender;

@property int numberForUpdate;

@property (nonatomic, retain) NSTimer *fadeTimer;

@end
