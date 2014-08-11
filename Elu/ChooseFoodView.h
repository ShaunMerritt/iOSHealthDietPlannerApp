//
//  ChooseFoodView.h
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Food;

@interface ChooseFoodView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Food *food;

-(instancetype)initWithFrame:(CGRect)frame
                        food:(Food *)food
                     options:(MDCSwipeToChooseViewOptions *)options;

@end
