//
//  SMMealPlanTableViewController.h
//  Elu
//
//  Created by Shaun Merritt on 9/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDayPicker.h"
#import "GHContextMenuView.h"


@interface SMMealPlanTableViewController : UITableViewController <GHContextOverlayViewDelegate, GHContextOverlayViewDataSource>

@property (nonatomic, strong) NSMutableArray *allMeals;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;

@property (weak, nonatomic) NSMutableDictionary *dictionaryOne;
@property (weak, nonatomic) NSMutableDictionary *dictionaryTwo;

@property int test;

@property int dayNumber;

@end
