//
//  SMYummlyGetClient.m
//  Elu
//
//  Created by Shaun Merritt on 7/26/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMYummlyGetClient.h"
#import "AFHTTPSessionManager.h"

static NSString *const SMBaseURL = @"http://api.yummly.com/v1/api/";
static NSString *const SMAppId = @"b8aacdf4";
static NSString *const SMAppKey = @"a8908fd1f6e4bff434989f91b138526e";

@implementation SMYummlyGetClient

+ (SMYummlyGetClient *)sharedSMYummlyGetHTTPClient
{
    static SMYummlyGetClient *_sharedSMYummlyGetHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSMYummlyGetHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SMBaseURL]];
    });
    
    return _sharedSMYummlyGetHTTPClient;
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

- (void)findRecipeWithId:(NSString *)recipeId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //parameters[@""] = recipeId;
    parameters[@"_app_id"] = SMAppId;
    parameters[@"_app_key"] = SMAppKey;
//    parameters[@"nutrition.CHOCDF.min"] = @"0";
//    parameters[@"nutrition.CHOCDF.max"] = @"20";
//    parameters[@"nutrition.PROCNT.min"] = @"20";
//    parameters[@"nutrition.PROCNT.max"] = @"50";
//
    
    NSString *sampleUrl = [NSString stringWithFormat:@"recipe/%@?",recipeId];
    NSString* encodedUrl = [sampleUrl stringByAddingPercentEscapesUsingEncoding:
                            NSASCIIStringEncoding];
    
    [self GET:encodedUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(yummlyGetHTTPClient:didUpdateWithRecipe:)]) {
            [self.delegate yummlyGetHTTPClient:self didUpdateWithRecipe:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(yummlyGetHTTPClient:didFailWithError:)]) {
            [self.delegate yummlyGetHTTPClient:self didFailWithError:error];
        }
    }];
}


@end
