//
//  SMNutritionViewController.h
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMYummlyHTTPClient.h"
#import "SMYummlyGetClient.h"
#import "SMNutritionixClient.h"
#import "SMNutritionixUPCClient.h"
#import "ZBarSDK.h"
#import "CHCSVParser.h"
#import "YLShareView.h"
#import "GHContextMenuView.h"
#import "SMLogFoodTableViewController.h"




@interface SMNutritionViewController : UIViewController <ZBarReaderDelegate, CHCSVParserDelegate, GHContextOverlayViewDelegate, GHContextOverlayViewDataSource>

- (IBAction)logout:(id)sender;
- (IBAction)scanItemButtonPressed:(id)sender;

@property (nonatomic, strong) NSArray       *allDoctors;
@property (nonatomic, strong) PFUser        *currentUser;
@property(nonatomic, weak) IBOutlet UIButton *centerButton;


@property (nonatomic, strong) NSMutableArray* shareItems;
@property (nonatomic, strong) YLShareView* shareView;
@property (nonatomic, weak) id<YLLongTapShareDelegate> delegate;

- (void)addShareItem:(YLShareItem*)item;

- (void)testMethod;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;


@end
