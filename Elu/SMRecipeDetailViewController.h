//
//  SMRecipeDetailViewController.h
//  
//
//  Created by Shaun Merritt on 9/14/14.
//
//

#import <UIKit/UIKit.h>
#import "Meal.h"

@interface SMRecipeDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;

@property (nonatomic, strong) NSMutableDictionary *recipeName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;



@property (weak, nonatomic) IBOutlet UIWebView *recipeWebView;


//
@property (nonatomic, strong) Meal *currentMeal;




@end
