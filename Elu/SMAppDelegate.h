//
//  SMAppDelegate.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Properties to be stored on physical device!!!
@property (readwrite, nonatomic) BOOL isDoctor;
@property (readwrite, nonatomic) BOOL hasBeenHere;

@property (nonatomic, copy) NSString *userName;
@property int totalCaloriesForMaintenece;


@end
