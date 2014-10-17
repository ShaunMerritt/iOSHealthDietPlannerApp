//
//  SMManuallyLogCaloriesEatenViewController.h
//  Elu
//
//  Created by Shaun Merritt on 10/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMManuallyLogCaloriesEatenViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    IBOutlet UITableView *tableViewInView;
    NSArray *mainArray;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsContoller;


@end
