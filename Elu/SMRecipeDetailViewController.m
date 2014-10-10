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


@interface SMRecipeDetailViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    
    NSURLRequest *requestForWebView = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.yummly.com/recipe/Hot-Turkey-Salad-Sandwiches-TasteOfHome"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 3];
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
