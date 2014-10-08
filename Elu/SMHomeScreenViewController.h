//
//  SMHomeScreenViewController.h
//  Elu
//
//  Created by Shaun Merritt on 7/23/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMYummlyHTTPClient.h"
#import "SMYummlyGetClient.h"
#import "PAImageView.h"

@interface SMHomeScreenViewController : UIViewController <SMYummlyHTTPClientDelegate, SMYummlyGetHTTPClientDelegate, PAImageViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *restrictionsLabel;

@property (weak, nonatomic) NSArray * allergiesArray;
@property int caloriesForCarbs;
@property int caloriesForFats;
@property int caloriesForProteins;
@property int caloriesForDay;
@property int calcium;
@property int cholesterol;
@property int fiber;
@property int iron;
@property int potassium;
@property int sodium;
@property int sugar;
@property int vitaminA;
@property int vitaminC;
@property int i;
@property int mealNumber;

@property (strong, nonatomic) IBOutlet PAImageView *imageView;

@property (nonatomic, strong) NSMutableArray *allMeals;
@property (nonatomic, strong) NSMutableArray *currentMeal;



@property int caloriesDedicatedToBreakfast;
@property int caloriesDedicatedToLunch;
@property int caloriesDedicatedToSnackBetweenLunchAndDinner;
@property int caloriesDedicatedToDinner;

@property int caloriesForFatsForBreakfast;
@property int caloriesForFatsForLunch;
@property int caloriesForFatsForDinner;

@property int caloriesForProteinsForBreakfast;
@property int caloriesForProteinsForLunch;
@property int caloriesForProteinsForDinner;

@property int caloriesForCarbsForBreakfast;
@property int caloriesForCarbsForLunch;
@property int caloriesForCarbsForDinner;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;






@property (strong, nonatomic) NSString *mealString;
@property (strong, nonatomic) NSString *plistPath;
@property (strong, nonatomic) NSData *plistData;

@property (strong, nonatomic) NSString *returnedRecipeID;
@property (strong, nonatomic) NSString *returnedRecipeName;
@property (strong, nonatomic) NSNumber *returnedRecipeTotalTimeInSeconds;
@property (strong, nonatomic) NSString *returnedRecipeCourse;
@property (strong, nonatomic) NSMutableDictionary *returnedRecipeFlavors;
@property (strong, nonatomic) NSString *returnedRecipeRating;

@property (strong, nonatomic) NSNumber *returnedRecipeYield;
@property (strong, nonatomic) NSMutableArray *returnedRecipeImagesArray;
@property (strong, nonatomic) NSMutableDictionary *returnedRecipeImagesDictionary;
@property (strong, nonatomic) NSString *returnedRecipeMediumImage;
@property (strong, nonatomic) NSString *returnedRecipeNumberOfServings;

@property int timeForPup;
@property int testValue;


//@property (nonatomic, strong) SMYummlyHTTPClient *client;




@end
