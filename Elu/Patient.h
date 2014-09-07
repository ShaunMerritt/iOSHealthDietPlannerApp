//
//  Patient.h
//  Elu
//
//  Created by Shaun Merritt on 8/22/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Details;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Details *patientDetails;

@end
