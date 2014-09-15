//
//  SMRecipeDetailViewController.m
//  
//
//  Created by Shaun Merritt on 9/14/14.
//
//

#import "SMRecipeDetailViewController.h"

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
    
   
   // NSLog(@"Recipe name: %@", recipeName);
    NSLog(@"The rating is: %@ star", [recipeName objectForKey:@"Rating"]);
    
    NSLog(@"HERE IS THE RECIPEEEE: %@", recipeName);
    
    self.calorieLabel.text = [recipeName objectForKey:@"Recipe Name"];
    
    
    //NSDictionary *dic = recipeName;
    
    //[recipeName objectForKey:@"entry"]
    
//    NSLog(@"Here is my dictionary: %@", dictionary);
//    
//    NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
//    NSLog(@"The total time is: %@ seconds", [dictionary objectForKey:@"Total Time In Seconds"]);
//    
//    NSDate *mealDate = [dictionary objectForKey:@"Date For Meal"];

    
    //_recipeNameLabel.text = recipeName;
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
