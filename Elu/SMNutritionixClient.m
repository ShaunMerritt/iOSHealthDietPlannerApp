//
//  SMNutritionixClient.m
//  Elu
//
//  Created by Shaun Merritt on 7/28/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMNutritionixClient.h"
#import "AFHTTPSessionManager.h"

static NSString *const SMBaseURL = @"https://api.nutritionix.com";
static NSString *const SMAppId = @"3ba33f4d";
static NSString *const SMAppKey = @"3b8f01ca64a3d758f3461605f13df49b";

@implementation SMNutritionixClient

+ (SMNutritionixClient *)sharedSMNutritionixHTTPClient {
    static SMNutritionixClient *_sharedSMNutritionixHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSMNutritionixHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SMBaseURL]];
    });
    
    return _sharedSMNutritionixHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void) searchForFoodItem:(NSString *)foodItem {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"phrase"] = foodItem;
    parameters[@"results"] = @"0:20";
    parameters[@"cal_min"] = @"0";
    parameters[@"cal_max"] = @"5000";
    parameters[@"fields"] = @"item_name,brand_name,item_id,brand_id";
    parameters[@"appId"] = @"3ba33f4d";
    parameters[@"appKey"] = @"3b8f01ca64a3d758f3461605f13df49b";
    
    [self GET:@"/v1_1/search/" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(nutritionixHTTPClient:didUpdateWithFoodItem:)]) {
            [self.delegate nutritionixHTTPClient:self didUpdateWithFoodItem:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(nutritionixHTTPClient:didFailWithError:)]) {
            [self.delegate nutritionixHTTPClient:self didFailWithError:error];
        }
    }];

    
}

@end
