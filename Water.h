//
//  Water.h
//  Elu
//
//  Created by Shaun Merritt on 10/3/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Water : NSManagedObject

@property (nonatomic, retain) NSNumber * numberOfCups;
@property (nonatomic, retain) NSDate * dateLogged;

@end
