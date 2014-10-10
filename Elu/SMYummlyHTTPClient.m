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

@implementation SMYummlyHTTPClient {
    NSString *amountOfCalories;
    BOOL firstTime;
}

+ (SMYummlyHTTPClient *)sharedSMYummlyHTTPClient {
    static SMYummlyHTTPClient *_sharedSMYummlyHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSMYummlyHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:SMBaseURL]];
    });
    
    return _sharedSMYummlyHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (int)calculateMinAndMax:(int)suggestedAmount {
    //NSLog(@"Suggested Amount: %d", suggestedAmount);
    //NSLog(@"Suggested Bool: %d", firstTime);

    if (firstTime == YES) {
        int myInt = suggestedAmount * -0.05;
        firstTime = NO;

        if (myInt < 1) {
            //NSLog(@"FIsrs time yes less");

            myInt = 0;
            //NSString *strValue = [@(myInt) stringValue];
            return myInt;
            firstTime = NO;
            
        } else {
            //NSLog(@"FIsrs time yes more");

            //NSString *strValue = [@(myInt) stringValue];
            return myInt;
            firstTime = NO;
        }
    } else if (firstTime == NO) {
        firstTime = YES;

        //NSLog(@"FIsrs time no");
        int myInt = suggestedAmount * 0.05;
        
       // NSString *strValue = [@(myInt) stringValue];
        return myInt;
    }
    return 0;
}

- (void)searchForRecipe:(NSString *)recipe meal:(NSString *)meal allergies:(NSArray *)allergies valueForCarbs:(int)valueForCarbs valueForFats:(int)valueForFats valueForProteins:(int)valueForProteins  {
    
   // valueForCalcium:(int)valueForCalcium valueForCholesterol:(int)valueForCholesterol valueForFiber:(int)valueForFiber valueForIron:(int)valueForIron valueForPotassium:(int)valueForPotassium valueForSodium:(int)valueForSodium valueForSugar:(int)valueForSugar valueForVitaminA:(int)valueForVitaminA valueForVitaminC:(int)valueForVitaminC
    
    
    //valueForVitaminA:(int)valueForVitaminA valueForVitaminC:(int)valueForVitaminC
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //NSLog(@"Par");
    parameters[@"_app_id"] = SMAppId;
    parameters[@"_app_key"] = SMAppKey;
    parameters[@"q"] = recipe;
    parameters[@"requirePictures"] = @"true";
    parameters[@"&allowedCourse[]"] = meal;
    
//    NSLog(@"MIN AND MAX %@", [self calculateMinAndMax:valueForFats]);
//    NSLog(@"MIN AND MAX %@", [self calculateMinAndMax:valueForFats]);
    
    for (NSString *x in allergies) {
        parameters[@"allowedAllergy[]"] = x;
    }

    firstTime = YES;
    int s = [self calculateMinAndMax:valueForFats];
    int d = [self calculateMinAndMax:valueForFats];

    parameters[@"nutrition.CHOCDF.min"] = [NSString stringWithFormat:@"%d", [self calculateMinAndMax:valueForFats]];
    parameters[@"nutrition.CHOCDF.max"] = [NSString stringWithFormat:@"%d", [self calculateMinAndMax:valueForFats]];
    
    parameters[@"nutrition.FAT.min"] = [NSString stringWithFormat:@"%d", [self calculateMinAndMax:valueForFats]];
    parameters[@"nutrition.FAT.max"] = [NSString stringWithFormat:@"%d", [self calculateMinAndMax:valueForFats]];
//
    parameters[@"nutrition.PROCNT.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForProteins]];
    parameters[@"nutrition.PROCNT.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForProteins]];

//    parameters[@"nutrition.CA.min"] = [self calculateMinAndMax:valueForCalcium];
//    parameters[@"nutrition.CA.max"] = [self calculateMinAndMax:valueForCalcium];

//    parameters[@"nutrition.CHOLE.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForCholesterol]];
//    parameters[@"nutrition.CHOLE.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForCholesterol]];
////
//    parameters[@"nutrition.FIBTG.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForFiber]];
//    parameters[@"nutrition.FIBTG.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForFiber]];
//
////    parameters[@"nutrition.FE.min"] = [self calculateMinAndMax:valueForIron];
////    parameters[@"nutrition.FE.max"] = [self calculateMinAndMax:valueForIron];
//
//    parameters[@"nutrition.K.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForPotassium]];
//    parameters[@"nutrition.K.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForPotassium]];
////
//    parameters[@"nutrition.NA.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForSodium]];
//    parameters[@"nutrition.NA.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForSodium]];
////
//    parameters[@"nutrition.SUGAR.min"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForSugar]];
//    parameters[@"nutrition.SUGAR.max"] = [NSString stringWithFormat:@"%d",[self calculateMinAndMax:valueForSugar]];

//    parameters[@"nutrition.VITA_IU.min"] = [self calculateMinAndMax:valueForVitaminA];
//    parameters[@"nutrition.VITA_IU.max"] = [self calculateMinAndMax:valueForVitaminA];
//
//    parameters[@"nutrition.VITC.min"] = [self calculateMinAndMax:valueForVitaminC];
//    parameters[@"nutrition.VITC.max"] = [self calculateMinAndMax:valueForVitaminC];

    
    
    //NSLog(@"Hear ere param %@", parameters);
    
    [self GET:@"recipes?" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"hello");
        if ([self.delegate respondsToSelector:@selector(yummlyHTTPClient:didUpdateWithFood:)]) {
            [self.delegate  yummlyHTTPClient:self didUpdateWithFood:responseObject];
          //  NSLog(@"Got here");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(yummlyHTTPClient:didFailWithError:)]) {
            [self.delegate yummlyHTTPClient:self didFailWithError:error];
           // NSLog(@"TESTS");
            //NSLog(@"%@", error);
        }
    }];
}

@end
