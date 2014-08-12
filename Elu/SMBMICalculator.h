//
//  SMBMICalculator.h
//  Elu
//
//  Created by Shaun Merritt on 7/29/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBMICalculator : NSObject

@property (assign) double heightOfPersonFeet;
@property (assign) double heightOfPersonInches;
@property (assign) double totalHeightOfPersonInInches;
@property (assign) double finalBMI;

- (int) patientsBodyMassIndexBasedOnWeightIs:(int)weight;

@end
