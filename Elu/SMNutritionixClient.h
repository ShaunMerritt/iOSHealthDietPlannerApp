//
//  SMNutritionixClient.h
//  Elu
//
//  Created by Shaun Merritt on 7/28/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@protocol SMNutritionixHTTPClientDelegate;

@interface SMNutritionixClient : AFHTTPSessionManager {
    
}

@property (nonatomic, weak) id<SMNutritionixHTTPClientDelegate>delegate;

+ (SMNutritionixClient *)sharedSMNutritionixHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)searchForFoodItem:(NSString *)foodItem;

@end

@protocol SMNutritionixHTTPClientDelegate <NSObject>
@optional
- (void)nutritionixHTTPClient:(SMNutritionixClient *)client didUpdateWithFoodItem:(id)foodItem;
- (void)nutritionixHTTPClient:(SMNutritionixClient *)client didFailWithError:(NSError *)error;



@end
