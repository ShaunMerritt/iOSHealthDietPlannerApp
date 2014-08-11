//
//  SMConstants.m
//  Elu
//
//  Created by Shaun Merritt on 7/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMConstants.h"

@implementation SMConstants

NSString *const kSMBaseURL = @"http://api.yummly.com/v1/api/recipes?_app_id=b8aacdf4&_app_key=a8908fd1f6e4bff434989f91b138526e&q=";
NSString *const kSMAllowedIngredient = @"&allowedIngredient[]=";
NSString *const kSMExcludeIngredient = @"&excludedIngredient[]=";
NSString *const kSMRequirePictures = @"&requirePictures=";
NSString *const kSMAllowedAllergy = @"&allowedAllergy[]=";
NSString *const kSMAllowedDiet = @"&allowedDiet[]=";
NSString *const kSMAllowedCuisine = @"&allowedCuisine[]=cuisine^cuisine-";
NSString *const kSMExcludedCuisine = @"&excludedCuisine[]=cuisine^cuisine-";
NSString *const kSMAllowedCourse = @"&allowedCourse[]=course^course-";
NSString *const kSMExcludedCourse = @"&excludedCourse[]=course^course-";
NSString *const kSMAllowedHoliday = @"&allowedHoliday[]=holiday^holiday-";
NSString *const kSMExcludedHoliday = @"&excludedHoliday[]=holiday^holiday-";
NSString *const kSMMaxTotalTimeInSeconds = @"&maxTotalTimeInSeconds=";

@end
