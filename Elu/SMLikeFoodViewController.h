//
//  SMLikeFoodViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseFoodView.h"

@interface SMLikeFoodViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Food *currentFood;
@property (nonatomic, strong) ChooseFoodView *frontCardView;
@property (nonatomic, strong) ChooseFoodView *backCardView;
@property (nonatomic, readwrite) NSMutableArray *likedFoodsArray;
@property (nonatomic, readwrite) NSUInteger numberOfItemsSwiped;

@property (nonatomic, copy  ) NSString   *name;
@property (nonatomic, strong) UIImage    *image;
@property (nonatomic, assign) NSString *age;
@property (nonatomic, assign) NSString *numberOfSharedFriends;
@property (nonatomic, assign) NSString *numberOfSharedInterests;
@property (nonatomic, assign) NSString *numberOfPhotos;

@end
