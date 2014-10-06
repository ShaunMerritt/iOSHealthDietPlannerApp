//
//  SMExerciseLoggingViewController.h
//  Elu
//
//  Created by Shaun Merritt on 10/4/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMExerciseLoggingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
    NSArray *mainArray;
}
@property (strong) NSManagedObject *exerciseObject;


@end
