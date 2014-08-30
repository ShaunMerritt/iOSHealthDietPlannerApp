//
//  Details.h
//  Elu
//
//  Created by Shaun Merritt on 8/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Details : NSManagedObject

@property (nonatomic, retain) NSString * arrayOfAllergies;
@property (nonatomic, retain) NSNumber * caloriesForCarbs;
@property (nonatomic, retain) NSNumber * caloriesForProteins;
@property (nonatomic, retain) NSNumber * caloriesForFats;
@property (nonatomic, retain) NSNumber * totalDailyCalories;
@property (nonatomic, retain) NSNumber * calcium;
@property (nonatomic, retain) NSNumber * cholesterol;
@property (nonatomic, retain) NSNumber * fiber;
@property (nonatomic, retain) NSNumber * iron;
@property (nonatomic, retain) NSNumber * potassium;
@property (nonatomic, retain) NSNumber * sodium;
@property (nonatomic, retain) NSNumber * sugar;
@property (nonatomic, retain) NSNumber * vitaminA;
@property (nonatomic, retain) NSNumber * vitaminC;
@property (nonatomic, retain) NSString * likedFoods;
@property (nonatomic, retain) NSManagedObject *details;

@end
