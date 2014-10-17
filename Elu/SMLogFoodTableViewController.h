//
//  SMLogFoodTableViewController.h
//  Elu
//
//  Created by Shaun Merritt on 9/14/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNutritionixClient.h"

@interface SMLogFoodTableViewController : UITableViewController <UISearchBarDelegate, SMNutritionixHTTPClientDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *loadedSearches;
//@property (strong, nonatomic) SMNutritionixClient *client;


@end
