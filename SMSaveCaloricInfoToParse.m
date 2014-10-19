//
//  SMSaveCaloricInfoToParse.m
//  Elu
//
//  Created by Shaun Merritt on 10/19/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMSaveCaloricInfoToParse.h"

@implementation SMSaveCaloricInfoToParse

+ (void) saveTotalCaloriesForDayToParse:(NSNumber *)amountOfCalories {
    
    // Set the liked food array to Liked_Food_Array on Parse
    [[PFUser currentUser] setObject:amountOfCalories forKey:@"Total_Calories_For_Day"];
    
    // Save the objects to parse
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];

    
}

+ (void) saveTotalCaloriesBurnedTodayToParse:(NSNumber *)amountOfCalories {
    
    // Set the liked food array to Liked_Food_Array on Parse
    [[PFUser currentUser] setObject:amountOfCalories forKey:@"Total_Calories_Burned_For_Day"];
    
    // Save the objects to parse
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    
}

+ (void) saveTotalCaloriesEatenTodayToParse:(NSNumber *)amountOfCalories {
    
    // Set the liked food array to Liked_Food_Array on Parse
    [[PFUser currentUser] setObject:amountOfCalories forKey:@"Total_Calories_Eaten_For_Day"];
    
    // Save the objects to parse
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
    }];
    
}

@end

