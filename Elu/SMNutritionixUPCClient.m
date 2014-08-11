//
//  SMNutritionixUPCClient.m
//  Elu
//
//  Created by Shaun Merritt on 7/28/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMNutritionixUPCClient.h"
#import "AFHTTPSessionManager.h"

static NSString *const SMBaseURL = @"https://api.nutritionix.com";
static NSString *const SMAppId = @"3ba33f4d";
static NSString *const SMAppKey = @"3b8f01ca64a3d758f3461605f13df49b";

@implementation SMNutritionixUPCClient

+ (SMNutritionixUPCClient *)sharedSMNutritionixUPCClient {
    static SMNutritionixUPCClient *_sharedSMNutritionixUPCClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSMNutritionixUPCClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SMBaseURL]];
    });
    
    return _sharedSMNutritionixUPCClient;
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

- (void) searchForItemIdFromUPCScan:(NSString *)itemId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"upc"] = itemId;
    parameters[@"appId"] = @"3ba33f4d";
    parameters[@"appKey"] = @"3b8f01ca64a3d758f3461605f13df49b";

    [self GET:@"/v1_1/item?" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(nutritionixUPCClient:didUpdateWithIdFromUPCScan:)]) {
            [self.delegate nutritionixUPCClient:self didUpdateWithIdFromUPCScan:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(nutritionixUPCClient:didFailWithError:)]) {
            [self.delegate nutritionixUPCClient:self didFailWithError:error];
        }
    }];
    
    
}

@end








