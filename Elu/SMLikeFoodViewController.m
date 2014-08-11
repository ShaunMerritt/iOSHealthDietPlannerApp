//
//  SMLikeFoodViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLikeFoodViewController.h"
#import "Food.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

static const CGFloat ChooseFoodButtonHorizontalPadding = 80.f;
static const CGFloat ChooseFoodButtonVerticalPadding = 20.f;

@interface SMLikeFoodViewController ()
@property (nonatomic, strong) NSMutableArray *foods;
@property (nonatomic, strong) NSMutableArray *allFoodsFromJSON;
@end

@implementation SMLikeFoodViewController

#pragma mark - Object Lifecycle

-(instancetype)init {
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        NSLog(@"init");
        //_foods = [[self defaultFoods] mutableCopy];
    }
    return self;
}

#pragma  mark - UIViewController Overrides

- (void)viewDidLoad {
    NSLog(@"load");
    _foods = [[self defaultFoods] mutableCopy];
    
    //_allFoodsFromJSON = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TeamMembers" ofType:@"json"]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSArray *make = json[@"team"];
    //NSLog(@"FOOD: %@ ", _foods);
    
//    for (NSDictionary *test in make) {
//        
//        _image = [UIImage imageNamed:[test valueForKey:@"image"]];
//        
//        _name = [test valueForKey:@"name"];
//        NSLog(@"NAME: %@", _name);
//        _age = [test valueForKey:@"title"];
//        _numberOfSharedFriends = [test valueForKey:@"location"];
//        _numberOfSharedInterests = [test valueForKey:@"location"];
//        _numberOfPhotos = [test valueForKey:@"location"];
//        
//        
//        [_foods addObject: [[Food alloc] initWithName:_name
//                              image:_image
//                                age:1
//              numberOfSharedFriends:2
//            numberOfSharedInterests:3
//                     numberOfPhotos:4]];
//        
//    }
//    
//    NSLog(@"all food: %@", _foods);



    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    NSLog(@"loaded");
    // Display the first ChooseFoodView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popFoodViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];
    
    // Display the second ChooseFoodView in back. This view controller uses
    // the MDCSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
    
    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
    self.likedFoodsArray = [[NSMutableArray alloc] init];

}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
-(void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@", self.currentFood.name);
}

// This is called then a user swipes the view fully left or right.
-(void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentFood.name);
        
    } else {
        NSLog(@"You liked %@.", self.currentFood.name);
        [self.likedFoodsArray addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
        NSLog(@"%@", self.likedFoodsArray);
        if ([self.foods count] <= self.numberOfItemsSwiped) {
            
            [[PFUser currentUser] setObject:self.likedFoodsArray forKey:@"Liked_Food_Array"];
            
            
            NSDictionary *dictionary = @{@"number": @"1",
                                         @"string": @"hi"};
            [[PFUser currentUser] setObject:dictionary forKey:@"testDictionary"];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                
                }
            }];
            
            UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"testName"];
            vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vcs animated:YES completion:nil];
            
            
            

        }
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popFoodViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.0;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

-(void) setFrontCardView:(ChooseFoodView *)frontCardView {
    // Keep track of the food currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentFood = frontCardView.food;
}


-(NSArray *)defaultFoods {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    
             
             
//             for (NSString *test in _foods) {
//                 
//                 _image = [UIImage imageNamed:[test valueForKey:@"image"]];
//                 
//                 _name = [test valueForKey:@"name"];
//                 _age = [test valueForKey:@"title"];
//                 _numberOfSharedFriends = [test valueForKey:@"location"];
//                 _numberOfSharedInterests = [test valueForKey:@"location"];
//                 _numberOfPhotos = [test valueForKey:@"location"];
//                 
//                 return @[
//                 [[Food alloc] initWithName:_name
//                                      image:_image
//                                        age:_age
//                      numberOfSharedFriends:_numberOfSharedFriends
//                    numberOfSharedInterests:_numberOfSharedInterests
//                             numberOfPhotos:_numberOfPhotos],
//                 ];
//             }
//    
    
            return @[
             
             [[Food alloc] initWithName:@"Barley"
                                  image:[UIImage imageNamed:@"Barley"]],
             [[Food alloc] initWithName:@"Bread"
                                  image:[UIImage imageNamed:@"Bread(products)"]],
             [[Food alloc] initWithName:@"Buckwheat"
                                  image:[UIImage imageNamed:@"Buckwheat"]],
             [[Food alloc] initWithName:@"Corn"
                                  image:[UIImage imageNamed:@"Corn "]],
             [[Food alloc] initWithName:@"Oats"
                                  image:[UIImage imageNamed:@"Oats"]],
             [[Food alloc] initWithName:@"Potatoes"
                                  image:[UIImage imageNamed:@"Potatoes"]],
             [[Food alloc] initWithName:@"Quinoa"
                                  image:[UIImage imageNamed:@"Quinoa"]],
             [[Food alloc] initWithName:@"Rice"
                                  image:[UIImage imageNamed:@"Rice"]],
             ];
    
    
    
//    [Food setupWithDictionary:[self.foods objectAtIndex:indexPath.row]];

    
    
}


-(ChooseFoodView *)popFoodViewWithFrame:(CGRect)frame {
    if ([self.foods count] == 0) {
        return nil;
    }
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a foodView with the top person in the people array, then pop
    // that person off the stack.
    ChooseFoodView *foodView = [[ChooseFoodView alloc] initWithFrame:frame
                                                                    food:self.foods[0]
                                                                   options:options];
    [self.foods removeObjectAtIndex:0];
    return foodView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChooseFoodButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChooseFoodButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChooseFoodButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChooseFoodButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end













