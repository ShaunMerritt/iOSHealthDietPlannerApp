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


@interface SMNutritionViewController : UITableViewController <SMYummlyHTTPClientDelegate, SMYummlyGetHTTPClientDelegate, SMNutritionixHTTPClientDelegate, SMNutritionixUPCClientDelegate, ZBarReaderDelegate, CHCSVParserDelegate>
- (IBAction)logout:(id)sender;
- (IBAction)scanItemButtonPressed:(id)sender;


@property (nonatomic, strong) SMAppDelegate *appDelegate;
@property (nonatomic, strong) NSArray       *allDoctors;
@property (nonatomic, strong) PFUser        *currentUser;

@end
