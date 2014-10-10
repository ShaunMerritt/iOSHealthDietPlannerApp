//
//  SMLikeFoodViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/30/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLikeFoodViewController.h"
#import "Food.h"
#import "SMHomeScreenViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "SMFirstTimePateientViewController.h"

static const CGFloat ChooseFoodButtonHorizontalPadding = 80.f;
static const CGFloat ChooseFoodButtonVerticalPadding = 20.f;

@interface SMLikeFoodViewController () {
    NSMutableArray *_likedBreakfasts;
    NSMutableArray *_likedLunches;
    NSMutableArray *_likedSnacks;
    NSMutableArray *_likedDinners;
}
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
        _foods = [[self defaultFoods] mutableCopy];
    }
    return self;
}

#pragma  mark - UIViewController Overrides

- (void)viewDidLoad {

    NSLog(@"Gpt here");
    
    _likedBreakfasts = [[NSMutableArray alloc] init];
    _likedLunches = [[NSMutableArray alloc] init];
    _likedSnacks = [[NSMutableArray alloc] init];
    _likedDinners = [[NSMutableArray alloc] init];

    
    _foods = [[self defaultFoods] mutableCopy];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [super viewDidLoad];
    
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
        // Didnt like food
        NSLog(@"You noped %@.", self.currentFood.name);
    } else {
        // Liked food
        NSLog(@"You liked %@.", self.currentFood.name);
        
        // Add food item to like array
        [self.likedFoodsArray addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
        
        
        if ([self.currentFood.meal.lowercaseString  isEqual: @"breakfast"]) {
            [_likedBreakfasts addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
            NSLog(@"%@", _likedBreakfasts);


        } else if ([self.currentFood.meal.lowercaseString  isEqual: @"lunch"]) {
            [_likedLunches addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
            NSLog(@"%@", _likedLunches);

            
        } else if ([self.currentFood.meal.lowercaseString  isEqual: @"snack"]) {
            [_likedSnacks addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
            NSLog(@"%@", _likedSnacks);

            
        } else {
            [_likedDinners addObject:[NSString stringWithFormat:@"%@",self.currentFood.name.lowercaseString]];
            NSLog(@"%@", _likedDinners);

            
        }
        
        
        

        
        // If all foods have been seen execute this.
        if ([self.foods count] <= self.numberOfItemsSwiped) {
            
            // Set the liked food array to Liked_Food_Array on Parse
            [[PFUser currentUser] setObject:self.likedFoodsArray forKey:@"Liked_Food_Array"];
            
            
            [[PFUser currentUser] setObject:_likedBreakfasts forKey:@"Liked_Breakfast_Array"];
            [[PFUser currentUser] setObject:_likedLunches forKey:@"Liked_Lunch_Array"];
            [[PFUser currentUser] setObject:_likedSnacks forKey:@"Liked_Snack_Array"];
            [[PFUser currentUser] setObject:_likedDinners forKey:@"Liked_Dinner_Array"];


            
            // This is how to make a dictionary and save it on parse. (Doesn't do anything, just here for fun)
            NSDictionary *dictionary = @{@"number": @"1",
                                         @"string": @"hi"};
            [[PFUser currentUser] setObject:dictionary forKey:@"testDictionary"];
            
            // Save the objects to parse
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                
                }
            }];
            
            // Move to different viewController
//            UIStoryboard *sbs        = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//            UIViewController *vcs    = [sbs instantiateViewControllerWithIdentifier:@"testName"];
//            vcs.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:vcs animated:YES completion:nil];
            
            //push profile view
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//            SMHomeScreenViewController *profileViewController = (SMHomeScreenViewController *)[storyboard instantiateViewControllerWithIdentifier:@"testName"];
//            
//            [self.navigationController pushViewController:profileViewController animated:YES];
        
            //execute segue programmatically
           //[self performSegueWithIdentifier: @"pushSegue" sender: self];
            
            
            // locally store the navigation controller since
            // self.navigationController will be nil once we are popped
            //[self.navigationController popViewControllerAnimated:YES];

            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
//            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            SMFirstTimePateientViewController *controller = [[SMFirstTimePateientViewController alloc] init];

            //[self removeFromParentViewController];
            
            NSString * storyboardName = @"MainStoryboard";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"hereIsTheID"];
            [self presentViewController:vc animated:YES completion:nil];
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

#pragma mark - Navigation


#pragma mark - Internal Methods

-(void) setFrontCardView:(ChooseFoodView *)frontCardView {
    // Keep track of the food currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentFood = frontCardView.food;
}


-(NSArray *)defaultFoods {

    // Create all of the food items
    return @[
             [[Food alloc] initWithName:@"Rice"
              image:[UIImage imageNamed:@"Rice"]
                                             meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Quinoa"
                                                     image:[UIImage imageNamed:@"Quinoa"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Potatoes"
                                                     image:[UIImage imageNamed:@"Potatoes"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Oatmeal"
                                                     image:[UIImage imageNamed:@"Oats"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Corn"
                                                     image:[UIImage imageNamed:@"Corn"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Buckwheat"
                                                     image:[UIImage imageNamed:@"Buckwheat"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Toast"
                                                     image:[UIImage imageNamed:@"Bread"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Barley"
                                                     image:[UIImage imageNamed:@"Barley"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Trout"
                                                     image:[UIImage imageNamed:@"Trout"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Clams"
                                                     image:[UIImage imageNamed:@"Clams"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Halibut"
                                                     image:[UIImage imageNamed:@"Halibut"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Seabass"
                                                     image:[UIImage imageNamed:@"Seabass"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Tuna"
                                                     image:[UIImage imageNamed:@"Tuna"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Oysters"
                                                     image:[UIImage imageNamed:@"Oysters"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Crab"
                                                     image:[UIImage imageNamed:@"Crab"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Salmon"
                                                     image:[UIImage imageNamed:@"Salmon"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Cod"
                                                     image:[UIImage imageNamed:@"Cod"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Lobster"
                                                     image:[UIImage imageNamed:@"Lobster"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Shrimp"
                                                     image:[UIImage imageNamed:@"Mexican Shrimp"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Pork"
                                                     image:[UIImage imageNamed:@"Pork"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Eggwhites"
                                                     image:[UIImage imageNamed:@"Eggwhite"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Lamb"
                                                     image:[UIImage imageNamed:@"Lamb"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Sunny Side Up Eggs"
                                                     image:[UIImage imageNamed:@"Egg"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Beef"
                                                     image:[UIImage imageNamed:@"Beef"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Turkey"
                                                     image:[UIImage imageNamed:@"Turkey"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Duck"
                                                     image:[UIImage imageNamed:@"Duck"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Chicken"
                                                     image:[UIImage imageNamed:@"Chicken"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Veal"
                                                     image:[UIImage imageNamed:@"Veal"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Walnuts"
                                                     image:[UIImage imageNamed:@"Walnut"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Veggie Burger"
                                                     image:[UIImage imageNamed:@"Veggie Burger"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"TVP"
                                                     image:[UIImage imageNamed:@"TVP"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Tofu"
                                                     image:[UIImage imageNamed:@"Tofu"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Soy Beans"
                                                     image:[UIImage imageNamed:@"Soy Beans"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Pistachios"
                                                     image:[UIImage imageNamed:@"Pistachios"]
                                                      meal:@"Snack"],
                      [[Food alloc] initWithName:@"Pinto Beans"
                                                     image:[UIImage imageNamed:@"Quinoa"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Pecans"
                                                     image:[UIImage imageNamed:@"Pecan"]
                                                      meal:@"Snack"],
                      [[Food alloc] initWithName:@"Peanuts"
                                                     image:[UIImage imageNamed:@"Peanuts"]
                                                      meal:@"Snack"],
                      [[Food alloc] initWithName:@"Peanut Butter"
                                                     image:[UIImage imageNamed:@"Peanut Butter"]
                                                      meal:@"Breakfast"],
                      [[Food alloc] initWithName:@"Lentils"
                                                     image:[UIImage imageNamed:@"Lentils"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Kashews"
                                                     image:[UIImage imageNamed:@"Kashews"]
                                                      meal:@"Snack"],
                      [[Food alloc] initWithName:@"Hazelnuts"
                                                     image:[UIImage imageNamed:@"Hazelnuts"]
                                                      meal:@"Snack"],
                      [[Food alloc] initWithName:@"Chickpeas"
                                                     image:[UIImage imageNamed:@"Chickpeas"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Black Eyed Peas"
                                                     image:[UIImage imageNamed:@"Black Eyed Peas"]
                                                      meal:@"Lunch"],
                      [[Food alloc] initWithName:@"Black Beans"
                                                     image:[UIImage imageNamed:@"Black Beans"]
                                                      meal:@"Dinner"],
                      [[Food alloc] initWithName:@"Almonds"
                                                     image:[UIImage imageNamed:@"Almonds"]
                                                      meal:@"Snack"],
                     [[Food alloc] initWithName:@"Zucchini"
                                                    image:[UIImage imageNamed:@"Zucchini"]
                                                     meal:@"Dinner"],
                     [[Food alloc] initWithName:@"Tomatos"
                                                    image:[UIImage imageNamed:@"Tomato"]
                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Sweet Potatoes"
//                                                    image:[UIImage imageNamed:@"Sweet Potatoes"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Squash"
//                                                    image:[UIImage imageNamed:@"Squash"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Spinach"
//                                                    image:[UIImage imageNamed:@"Spinach"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Radishes"
//                                                    image:[UIImage imageNamed:@"Radish"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Pumpkin Seeds"
//                                                    image:[UIImage imageNamed:@"Pumpkin"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Onions"
//                                                    image:[UIImage imageNamed:@"Onions"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Mushrooms"
//                                                    image:[UIImage imageNamed:@"Mushrooms"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Kale"
//                                                    image:[UIImage imageNamed:@"Kale"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Green Beans"
//                                                    image:[UIImage imageNamed:@"Green Beans"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Eggplant"
//                                                    image:[UIImage imageNamed:@"Eggplant"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Cucumber"
//                                                    image:[UIImage imageNamed:@"Cucumber"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Cauliflower"
//                                                    image:[UIImage imageNamed:@"Coliflour"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Celery"
//                                                    image:[UIImage imageNamed:@"Celery"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Carrots"
//                                                    image:[UIImage imageNamed:@"Carrots"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Coleslaw"
//                                                    image:[UIImage imageNamed:@"Cabbage"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Roasted Brussel Sprouts"
//                                                    image:[UIImage imageNamed:@"Brussel Sprouts"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Steamed Broccoli"
//                                                    image:[UIImage imageNamed:@"Brocolli"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Bell Pepper"
//                                                    image:[UIImage imageNamed:@"Bell Pepper"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Beets"
//                                                    image:[UIImage imageNamed:@"Beets"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Avocado"
//                                                    image:[UIImage imageNamed:@"Avocado "]
//                                                     meal:@"Breakfast"],
//                     [[Food alloc] initWithName:@"Asparagus"
//                                                    image:[UIImage imageNamed:@"Asparagus"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Steamed Artichoke"
//                                                    image:[UIImage imageNamed:@"Artichoke"]
//                                                     meal:@"Dinner"],
//                     [[Food alloc] initWithName:@"Watermelon"
//                                                    image:[UIImage imageNamed:@"Watermelon"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Tangerine"
//                                                    image:[UIImage imageNamed:@"Tangerine"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Strawberries"
//                                                    image:[UIImage imageNamed:@"Strawberries "]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Rasberries"
//                                                    image:[UIImage imageNamed:@"Rasberries"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Raisins"
//                                                    image:[UIImage imageNamed:@"Raisins"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Prunes"
//                                                    image:[UIImage imageNamed:@"Prunes "]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Plums"
//                                                    image:[UIImage imageNamed:@"Plum"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Pineapples"
//                                                    image:[UIImage imageNamed:@"Pineapple"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Pears"
//                                                    image:[UIImage imageNamed:@"Pear"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Peach"
//                                                    image:[UIImage imageNamed:@"Peach"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Papayas"
//                                                    image:[UIImage imageNamed:@"Papayas"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Oranges"
//                                                    image:[UIImage imageNamed:@"Orange "]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Nectarines"
//                                                    image:[UIImage imageNamed:@"Nectarines"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Mangoes"
//                                                    image:[UIImage imageNamed:@"Mangoes "]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Lime"
//                                                    image:[UIImage imageNamed:@"Lime"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Lemons"
//                                                    image:[UIImage imageNamed:@"Lemons"]
//                                                     meal:@"Lunch"],
//                     [[Food alloc] initWithName:@"Kiwi"
//                                                    image:[UIImage imageNamed:@"Kiwi"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Honeydew"
//                                                    image:[UIImage imageNamed:@"Honeydew"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Grapes"
//                                                    image:[UIImage imageNamed:@"Grapes"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Grapefruit"
//                                                    image:[UIImage imageNamed:@"Grapefruit "]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Cherries"
//                                                    image:[UIImage imageNamed:@"Cherry"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Cantaloupes"
//                                                    image:[UIImage imageNamed:@"Cantaloupe"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Blueberries"
//                                                    image:[UIImage imageNamed:@"Blueberries"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Banana"
//                                                    image:[UIImage imageNamed:@"Banana"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Apricots"
//                                                    image:[UIImage imageNamed:@"Apricot"]
//                                                     meal:@"Snack"],
//                     [[Food alloc] initWithName:@"Apples"
//                                                    image:[UIImage imageNamed:@"Apple"]
//                                                     meal:@"Snack"],
     ];
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setHidesBottomBarWhenPushed:NO];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController.toolbar setHidden: NO];
    
}

@end














