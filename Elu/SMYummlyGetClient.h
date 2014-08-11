//
//  SMYummlyGetClient.h
//  Elu
//
//  Created by Shaun Merritt on 7/26/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@protocol SMYummlyGetHTTPClientDelegate;

@interface SMYummlyGetClient : AFHTTPSessionManager {
    
}

@property (nonatomic, weak) id<SMYummlyGetHTTPClientDelegate>delegate;

+ (SMYummlyGetClient *)sharedSMYummlyGetHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)findRecipeWithId:(NSString *)recipeId;

@end

@protocol SMYummlyGetHTTPClientDelegate <NSObject>
@optional
- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didUpdateWithRecipe:(id)recipe;
- (void)yummlyGetHTTPClient:(SMYummlyGetClient *)client didFailWithError:(NSError *)error;

@end
