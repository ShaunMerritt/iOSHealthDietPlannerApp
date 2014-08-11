//
//  SMLikeFoodsTableViewController.h
//  Elu
//
//  Created by Shaun Merritt on 7/1/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLikesFoodTableViewCell.h"

@interface SMLikeFoodsTableViewController : UITableViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *foods;
@property (strong, nonatomic) IBOutlet UITableView *tableViewForFoods;
@property (strong, nonatomic) SMLikesFoodTableViewCell *cell;






@end
