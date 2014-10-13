//
//  Meal.h
//  Elu
//
//  Created by Shaun Merritt on 10/6/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meal : NSManagedObject

@property (nonatomic, retain) NSDate * dateForMeal;
@property (nonatomic, retain) NSString * recipeName;
@property (nonatomic, retain) NSNumber * timeInSeconds;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * mealNumber;
@property (nonatomic, retain) NSNumber * numberOfServings;
@property (nonatomic, retain) NSNumber * recipeRating;
@property (nonatomic, retain) NSNumber * recipeYield;
@property (nonatomic, retain) NSString * recipeID;
@property (nonatomic, retain) NSString * recipeURL;
@property (nonatomic, retain) NSNumber * numberOfCalories;


@end
