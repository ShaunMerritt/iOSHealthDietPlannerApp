//
//  SMDataSourceForPageViewController.h
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageContentOneViewController.h"
#import "SMPageContentTwoViewController.h"

@interface SMDataSourceForPageViewController : UIViewController <UIPageViewControllerDataSource> {
    
}

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *viewControllers;


@end
