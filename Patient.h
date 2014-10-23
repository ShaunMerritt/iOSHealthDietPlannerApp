//
//  Patient.h
//  Elu
//
//  Created by Shaun Merritt on 10/21/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Details;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * totalCaloriesBurnedToday;
@property (nonatomic, retain) NSNumber * totalCaloriesEatenToday;
@property (nonatomic, retain) NSNumber * totalCaloriesForDay;
@property (nonatomic, retain) NSNumber * signedUp;
@property (nonatomic, retain) Details *patientDetails;

@end
