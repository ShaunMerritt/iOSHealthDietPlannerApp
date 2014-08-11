//
//  SMYummlyHTTPClient.h
//  Elu
//
//  Created by Shaun Merritt on 7/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

@protocol SMYummlyHTTPClientDelegate;

@interface SMYummlyHTTPClient : AFHTTPSessionManager {
    
}

@property (nonatomic, weak) id<SMYummlyHTTPClientDelegate>delegate;

+ (SMYummlyHTTPClient *)sharedSMYummlyHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)searchForRecipe:(NSString *)recipe;

@end

@protocol SMYummlyHTTPClientDelegate <NSObject>
@optional
-(void)yummlyHTTPClient:(SMYummlyHTTPClient *)client didUpdateWithFood:(id)food;
-(void)yummlyHTTPClient:(SMYummlyHTTPClient *)client didFailWithError:(NSError *)error;
 
@end
