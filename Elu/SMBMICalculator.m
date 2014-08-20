//
//  SMBMICalculator.m
//  Elu
//
//  Created by Shaun Merritt on 7/29/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMBMICalculator.h"
#import <math.h>

@implementation SMBMICalculator {
    double _feetToInches;
    double _totalHeightInInches;
    double _heightSquared;
    double _weightDividedByInchesSquared;
}

- (int) patientsBodyMassIndexBasedOnWeightIs:(int)weight {
    
    _feetToInches = _heightOfPersonFeet * 12;
    _totalHeightInInches = _feetToInches + _heightOfPersonInches;
    
    NSLog(@"%f total heigh itn inch", _totalHeightInInches);
    
    _heightSquared = pow(_totalHeightInInches, 2);
    NSLog(@"%f height squared", _heightSquared);
    NSLog(@"%i weight", weight);

    _weightDividedByInchesSquared = weight/_heightSquared;
    NSLog(@"%f total weight div", _weightDividedByInchesSquared);

    _finalBMI = _weightDividedByInchesSquared * 703;
    
    return _finalBMI;
}


@end
