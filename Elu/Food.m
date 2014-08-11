//
//  Food.m
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "Food.h"

@implementation Food

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
    }
    NSLog(@"SELF : %@", self);
    return self;
}

- (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image
                         age:(NSUInteger)age
       numberOfSharedFriends:(NSUInteger)numberOfSharedFriends
     numberOfSharedInterests:(NSUInteger)numberOfSharedInterests
              numberOfPhotos:(NSUInteger)numberOfPhotos {
    self = [super init];
    if (self) {
        _name = name;
        _image = image;
        _age = age;
        _numberOfSharedFriends = numberOfSharedFriends;
        _numberOfSharedInterests = numberOfSharedInterests;
        _numberOfPhotos = numberOfPhotos;
    }
    return self;
}

@end
