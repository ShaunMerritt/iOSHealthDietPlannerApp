//
//  YummlyGetModel.h
//  Elu
//
//  Created by Shaun Merritt on 7/26/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "JSONModel.h"

@interface YummlyGetModel : JSONModel


@property (strong, nonatomic) NSString* totalTime;
@property (strong, nonatomic) NSString* yield;
@property (nonatomic) NSInteger numberOfServings;




@end
