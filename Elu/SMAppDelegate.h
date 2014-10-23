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


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (assign) BOOL signedOut;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end
