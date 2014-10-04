//
//  SMWaterLogViewController.h
//  Elu
//
//  Created by Shaun Merritt on 10/3/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

@import CoreData;
#import <UIKit/UIKit.h>


@interface SMWaterLogViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *amountOfWaterLabel;
- (IBAction)minusOneCupButton:(id)sender;
- (IBAction)addOneCupButton:(id)sender;
@property (strong) NSManagedObject *cupsOfWaterObject;


@end
