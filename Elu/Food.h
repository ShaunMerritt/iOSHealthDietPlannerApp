//
//  Food.h
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Food : NSObject



- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                        meal:(NSString *)meal;

@property (nonatomic, copy  ) NSString   *name;
@property (nonatomic, strong) UIImage    *image;
@property (nonatomic, strong) NSString *meal;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) NSUInteger numberOfSharedFriends;
@property (nonatomic, assign) NSUInteger numberOfSharedInterests;
@property (nonatomic, assign) NSUInteger numberOfPhotos;

@end
