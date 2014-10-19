//
//  SMSaveCaloricInfoToParse.h
//  Elu
//
//  Created by Shaun Merritt on 10/19/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSaveCaloricInfoToParse : NSObject

+ (void) saveTotalCaloriesForDayToParse:(NSNumber *)amountOfCalories;

+ (void) saveTotalCaloriesBurnedTodayToParse:(NSNumber *)amountOfCalories;

+ (void) saveTotalCaloriesEatenTodayToParse:(NSNumber *)amountOfCalories;



@end
