//
//  YummlyModel.h
//  Elu
//
//  Created by Shaun Merritt on 7/25/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "JSONModel.h"

@interface YummlyModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSArray* ingredients;
@property (strong, nonatomic) NSString* recipeName;
@property (strong, nonatomic) NSString* totalTimeInSeconds;
@property (strong, nonatomic) NSString* sourceDisplayName;
@property (nonatomic) NSInteger rating;





@end
