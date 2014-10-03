//
//  SMNutritionixUPCClient.h
//  Elu
//
//  Created by Shaun Merritt on 7/28/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@protocol SMNutritionixUPCClientDelegate;

@interface SMNutritionixUPCClient : AFHTTPSessionManager {
    
}

@property (nonatomic, weak) id<SMNutritionixUPCClientDelegate>delegate;

+ (SMNutritionixUPCClient *)sharedSMNutritionixUPCClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)searchForItemIdFromUPCScan:(NSString *)itemId;

@end

@protocol SMNutritionixUPCClientDelegate <NSObject>
@optional
- (void)nutritionixUPCClient:(SMNutritionixUPCClient *)client didUpdateWithIdFromUPCScan:(id)itemId;
- (void)nutritionixUPCClient:(SMNutritionixUPCClient *)client didFailWithError:(NSError *)error;

@end
