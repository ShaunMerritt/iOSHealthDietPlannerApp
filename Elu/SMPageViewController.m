//
//  SMPageViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMPageViewController.h"

@interface SMPageViewController () <UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *pages;
@property int index;
@end

@implementation SMPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.index = 0;
    
    self.pages = [[NSMutableArray alloc] init];
    [self.pages addObject:@"FirstPageController"];
    [self.pages addObject:@"SecondPageController"];
    SMFirstPageForPageViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstPageController"];
    
    [self setViewControllers:@[firstVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    self.index++;
    if (self.index == 0) {
        SMFirstPageForPageViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.pages objectAtIndex:0]];
        return newVC;
    } else if (self.index == 1) {
        SMSecondPageForPageViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.pages objectAtIndex:1]];
        return newVC;
    } else if (self.index > 1) {
        return nil;
    }
    return 0;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    self.index--;
    if (self.index == 0) {
        SMFirstPageForPageViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.pages objectAtIndex:0]];
        return newVC;
    } else if (self.index == 1) {
        SMSecondPageForPageViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.pages objectAtIndex:1]];
        return newVC;
    } else if (self.index < 0) {
        return nil;
    }
    return 0;
    
}

@end
