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

@interface SMYummlyHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<SMYummlyHTTPClientDelegate>delegate;

+ (SMYummlyHTTPClient *)sharedSMYummlyHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)searchForRecipe:(NSString *)recipe meal:(NSString *)meal allergies:(NSArray *)allergies valueForCarbs:(int)valueForCarbs valueForFats:(int)valueForFats valueForProteins:(int)valueForProteins valueForCalcium:(int)valueForCalcium valueForCholesterol:(int)valueForCholesterol valueForFiber:(int)valueForFiber valueForIron:(int)valueForIron valueForPotassium:(int)valueForPotassium valueForSodium:(int)valueForSodium valueForSugar:(int)valueForSugar valueForVitaminA:(int)valueForVitaminA valueForVitaminC:(int)valueForVitaminC;

    //  valueForCarbs:(int)valueForCarbs valueForFats:(int)valueForFats valueForProteins:(int)valueForProteins valueForCalcium:(int)valueForCalcium valueForCholesterol:(int)valueForCholesterol valueForFiber:(int)valueForFiber valueForIron:(int)valueForIron valueForPotassium:(int)valueForPotassium valueForSodium:(int)valueForSodium valueForSugar:(int)valueForSugar

    //valueForVitaminA:(int)valueForVitaminA valueForVitaminC:(int)valueForVitaminC

@end

@protocol SMYummlyHTTPClientDelegate <NSObject>
@optional
-(void)yummlyHTTPClient:(SMYummlyHTTPClient *)client didUpdateWithFood:(id)food;
-(void)yummlyHTTPClient:(SMYummlyHTTPClient *)client didFailWithError:(NSError *)error;
 
@end
