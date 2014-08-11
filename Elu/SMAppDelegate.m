//
//  SMAppDelegate.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMLikeFoodsTableViewController.h"
#import "SMFood.h"
//#import "AFNetworking.h"
#import "YummlyModel.h"

@implementation SMAppDelegate {
    NSMutableArray *_foods;
    NSArray* returnedFoods;
}
@synthesize isDoctor;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"d9xTmAjHJXo1tiW1mGacy4pD26Nk6ACajDYfoeHU"
                  clientKey:@"y58tkd1AM5Gx83PRvnwN8riwuO0fURwJtVjh7Dpa"];
    
    /*
    
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@eggs", kSMBaseURL]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self didReceiveJSON: responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operation start];
     
     */
    
    
    
    
    
    
//    [PFCloud callFunctionInBackground:@"generateRecommendedCaloriesForMen"
//                       withParameters: @{@"weight": @"10", @"activityNumber": @"10"}
//                                block:^(NSString *object, NSError *error) {
//                                    if (!error) {
//                                        NSLog(@"Here is the object: %@",object);
//                                        NSLog(@"%@", [PFUser currentUser].username);
//                                        //self.uniqueCodeLabel.text = newPatient.password;
//                                        
//                                        NSString *recommendedDailyCaloriesForMaintenece = object;
//                                        [[PFUser currentUser] setObject:recommendedDailyCaloriesForMaintenece forKey:@"RecommendedCaloriesForMaintenece"];
//
//                                        //Save all data to Parse
//                                        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                            if (!error) {
//                                                //[self dismissModalViewControllerAnimated:YES];
//                                            }
//                                        }];
//                                        
//                                        
//                                        
//                                    }
//                                    else {
//                                        NSLog(@"%@, %@", error,[error userInfo]);
//                                        NSLog(@"%@", [PFUser currentUser].username);
//                                    }
//                                }];
//
//    
//    
    
    
    [self load];
    
    return YES;
}

- (void) didReceiveJSON: (NSDictionary*)obj {
    NSArray *matches = obj[@"matches"];
    
    @try {
        returnedFoods = [YummlyModel arrayOfModelsFromDictionaries:matches];
    }
    @catch (NSException *exception) {
        NSLog(@"AFNETWORK ERROR");
    }
    
    [self log];
    
}

- (void) log {
    YummlyModel* food = returnedFoods[0];
    NSLog(@"%@", food.id);
    NSLog(@"%@", food.ingredients);
    NSLog(@"%@", food.recipeName);
    NSLog(@"%@", food.totalTimeInSeconds);
    NSLog(@"%@", food.sourceDisplayName);
    NSLog(@"%@", food.rating);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self save];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self save];
}

- (void) load {
    isDoctor = [[NSUserDefaults standardUserDefaults] integerForKey:@"isDoctor"];
}

- (void) save {
    [[NSUserDefaults standardUserDefaults] setBool:isDoctor forKey:@"isDoctor"];
}

@end
