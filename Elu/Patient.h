//
//  Patient.h
//  Pods
//
//  Created by Shaun Merritt on 10/17/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Details;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * totalCaloriesForDay;
@property (nonatomic, retain) NSNumber * totalCaloriesBurnedToday;
@property (nonatomic, retain) NSNumber * totalCaloriesEatenToday;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Details *patientDetails;

@end
