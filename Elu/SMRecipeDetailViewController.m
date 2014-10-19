//
//  SMRecipeDetailViewController.m
//  
//
//  Created by Shaun Merritt on 9/14/14.
//
//

#import "SMRecipeDetailViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Patient.h"
#import "SMSaveCaloricInfoToParse.h"


@interface SMRecipeDetailViewController () {
    
}

@end

@implementation SMRecipeDetailViewController
@synthesize recipeName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)handleSwipe{
    NSLog(@"here");
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //[self.navigationController setToolbarHidden:NO animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.recipeWebView.frame = CGRectMake(self.recipeWebView.frame.origin.x, self.recipeWebView.frame.origin.y + 100, self.recipeWebView.frame.size.width, self.recipeWebView.frame.size.height - 250);
        }];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //[self.navigationController setToolbarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.recipeWebView.frame = CGRectMake(self.recipeWebView.frame.origin.x, self.recipeWebView.frame.origin.y - 250, self.recipeWebView.frame.size.width, self.recipeWebView.frame.size.height + 250);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    
    UISwipeGestureRecognizer *swipeGestureRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    
    swipeGestureRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [self.view addGestureRecognizer:swipeGestureRecognizerDown];

    
    // Do any additional setup after loading the view.
    
    //NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    //dictionary = [recipeName objectAtIndex:0];
    
   
//   // NSLog(@"Recipe name: %@", recipeName);
//    NSLog(@"The rating is: %@ star", [recipeName objectForKey:@"Rating"]);
//    
//    NSLog(@"HERE IS THE RECIPEEEE: %@", recipeName);
//    
//    self.calorieLabel.text = [recipeName objectForKey:@"Recipe Name"];
//    
//    
//    //NSDictionary *dic = recipeName;
//    
//    //[recipeName objectForKey:@"entry"]
//    
////    NSLog(@"Here is my dictionary: %@", dictionary);
////    
////    NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
////    NSLog(@"The total time is: %@ seconds", [dictionary objectForKey:@"Total Time In Seconds"]);
////    
////    NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];
//
//    
//    //_recipeNameLabel.text = recipeName;


    _recipeNameLabel.text = _currentMeal.recipeName;
    
    _calorieLabel.text = [NSString stringWithFormat:@"%@", _currentMeal.numberOfCalories];
    
    
    NSURLRequest *requestForWebView = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@",_currentMeal.recipeURL]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 3];
    [_recipeWebView loadRequest: requestForWebView];
    
    NSURL *url = [NSURL URLWithString:_currentMeal.imageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    
    [_recipeImage setImageWithURLRequest:request
                       placeholderImage:placeholderImage
                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                    
                                    
                                    _recipeImage.image = image;
                                    
                                    
                                } failure:nil];
    

    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (IBAction)logRecommendedRecipe:(id)sender {
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Patient" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"date == %@", [self calculateCurrentDateWithTimeSetToZero]];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    Patient *newVehicle = [results objectAtIndex:0];
    
    NSNumber *sum = [NSNumber numberWithFloat:([newVehicle.totalCaloriesEatenToday floatValue] + [_currentMeal.numberOfCalories floatValue])];
    [newVehicle setValue: sum forKey:@"totalCaloriesEatenToday"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesEatenTodayToParse:sum];

    
    NSNumber *sumOfTotalForDay = [NSNumber numberWithFloat:([newVehicle.totalCaloriesForDay floatValue] + [_currentMeal.numberOfCalories floatValue])];
    [newVehicle setValue: sumOfTotalForDay forKey:@"totalCaloriesBurnedToday"];
    [SMSaveCaloricInfoToParse saveTotalCaloriesBurnedTodayToParse:sumOfTotalForDay];

    
    
    [self.managedObjectContext save:nil];
    

        
        
    

    
}

- (NSDate *)calculateCurrentDateWithTimeSetToZero {
    
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    return dateOnly;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
