//
//  SMDataSourceForPageViewController.m
//  Elu
//
//  Created by Shaun Merritt on 8/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDataSourceForPageViewController.h"

@interface SMDataSourceForPageViewController ()
@property (nonatomic, strong) NSMutableArray *vc;
@property (nonatomic, strong) NSArray *vc1;

@end

@implementation SMDataSourceForPageViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSLog(@"HEREEEEE");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    [_vc addObject:@"PageContentControllerOne"];
    [_vc addObject:@"PageContentControllerTwo"];
    
    SMPageContentOneViewController *startingViewController = [self viewControllerAtIndex:0];
    _vc1 = @[startingViewController];

    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSString * ident = viewController.restorationIdentifier;
    NSUInteger index = [_vc indexOfObject:ident];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    //notice here I call my instantiation method again essentially duplicating work I have already done!
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSString * ident = viewController.restorationIdentifier;
    NSUInteger index = [_vc indexOfObject:ident];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"GOT HERE");
    // Create a new view controller and pass suitable data.
    if (index == 0) {
        SMPageContentOneViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:[_vc objectAtIndex:index]];
        NSLog(@"HEREEERERERERERRERRERERERERERERER");
                return fvc;
    } else if (index == 1) {
        SMPageContentTwoViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:[_vc objectAtIndex:index]];
        return fvc;
    }
    
    SMPageContentOneViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:[_vc objectAtIndex:index]];
    NSLog(@"HEREEERERERERERRERRERERERERERERER");

    return fvc;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
