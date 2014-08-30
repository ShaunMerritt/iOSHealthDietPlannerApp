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

@interface SMHomeScreenViewController : UIViewController <SMYummlyHTTPClientDelegate, SMYummlyGetHTTPClientDelegate>

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


@property int caloriesDedicatedToBreakfast;
@property int caloriesDedicatedToLunch;
@property int caloriesDedicatedToSnackBetweenLunchAndDinner;
@property int caloriesDedicatedToDinner;

@property (strong, nonatomic) NSString *mealString;
@property (strong, nonatomic) NSString *plistPath;
@property (strong, nonatomic) NSData *plistData;



//@property (nonatomic, strong) SMYummlyHTTPClient *client;




@end
