//
//  SMYummlyHTTPClient.m
//  Elu
//
//  Created by Shaun Merritt on 7/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMYummlyHTTPClient.h"
#import "AFHTTPSessionManager.h"

static NSString *const SMBaseURL = @"http://api.yummly.com/v1/api/";
static NSString *const SMAppId = @"b8aacdf4";
static NSString *const SMAppKey = @"a8908fd1f6e4bff434989f91b138526e";

@implementation SMYummlyHTTPClient

+ (SMYummlyHTTPClient *)sharedSMYummlyHTTPClient
{
    static SMYummlyHTTPClient *_sharedSMYummlyHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSMYummlyHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SMBaseURL]];
    });
    
    return _sharedSMYummlyHTTPClient;
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

- (void)searchForRecipe:(NSString *)recipe
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"_app_id"] = SMAppId;
    parameters[@"_app_key"] = SMAppKey;
    parameters[@"q"] = recipe;
    
    NSLog(@"%@", parameters);
    
    [self GET:@"recipes?" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(yummlyHTTPClient:didUpdateWithFood:)]) {
            [self.delegate  yummlyHTTPClient:self didUpdateWithFood:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(yummlyHTTPClient:didFailWithError:)]) {
            [self.delegate yummlyHTTPClient:self didFailWithError:error];
            NSLog(@"TESTS");
            NSLog(@"%@", error);
        }
    }];
}

@end
