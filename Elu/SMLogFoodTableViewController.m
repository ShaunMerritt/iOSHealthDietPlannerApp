//
//  SMLogFoodTableViewController.m
//  Elu
//
//  Created by Shaun Merritt on 9/14/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLogFoodTableViewController.h"
//#import "SMNutritionixClient.h"

@interface SMLogFoodTableViewController ()

@end

@implementation SMLogFoodTableViewController {
    NSMutableDictionary *itemsReturned;
    NSDictionary *weather;
    NSDictionary *_threeItemsReturned;
    NSMutableDictionary *_returnedFoodItem;
    NSMutableArray *_returnedItems;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _searchBar.placeholder = @"Search for food";
    _threeItemsReturned = [[NSDictionary alloc] init];
    
    
//    _client = [SMNutritionixClient sharedSMNutritionixHTTPClient];
//    _client.delegate = self;
    
//    SMNutritionixClient *nutrition = [SMNutritionixClient sharedSMNutritionixHTTPClient];
//    nutrition.delegate = self;
//    [nutrition searchForFoodItem:@"tacos"];
//    
    
    
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return weather.count;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
    
    _threeItemsReturned = nil;
    NSString *textForTheSearch = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSString *string = [NSString stringWithFormat:@"https://api.nutritionix.com/v1_1/search/%@?results=0:20&cal_min=0&cal_max=50000&fields=item_name,brand_name,item_id,brand_id&appId=3ba33f4d&appKey=3b8f01ca64a3d758f3461605f13df49b", textForTheSearch];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        weather = (NSDictionary *)responseObject;
        NSLog(@"Weather Here: %@", weather);
        self.title = @"JSON Retrieved";
        
        NSArray *test = [[NSArray alloc] init];
        test = [weather objectForKey:@"hits"];

        for (NSDictionary *arrayOfMeals in test) {
            
            
            NSDictionary* fields = [arrayOfMeals objectForKey:@"fields"];
            NSString* item_name = [fields objectForKey:@"item_name"];
            
            NSLog(@"Items are here: %@", item_name);
            
            
        }
        
        
        
        
        
        NSLog(@"Weather: %@", weather);
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
    
    
    

    
    
    
   
    
    //[_client searchForFoodItem:searchText];
    
    
}
//
//- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didUpdateWithFoodItem:(id)foodItem {
//    itemsReturned = foodItem;
//    NSLog(@"FOOD ITEM HERE: %@", foodItem);
//    NSLog(@"Foof item count: %lu", (unsigned long)itemsReturned.count);
//    
//    
//
//    
//    NSLog(@"Here is loaded searches: %@", _loadedSearches);
//    
//    
//    [self logItemsReturned];
//    
//    [self.tableView reloadData];
//}
//
//- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didFailWithError:(NSError *)error {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString 						stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
//    
//    [alert show];
//}
//
//- (void) logItemsReturned {
//    
//    // Create dictionary and generate key mapping structure
//    NSDictionary *test = [[NSDictionary alloc] init];
//    test = [itemsReturned objectForKey:@"hits"];
//    
//    NSArray* listOfMatchingFoods = [itemsReturned objectForKey:@"hits"]; //2
//    
//    
//    
//    
////    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:0];
////    
////    NSLog(@"BEST FOOD MATCH: %@", bestFoodMatch);
////    
////    NSString* index = [bestFoodMatch objectForKey:@"_index"];
////    NSString* type = [bestFoodMatch objectForKey:@"_type"];
////    NSString* score = [bestFoodMatch objectForKey:@"_score"];
////    NSString* id = [bestFoodMatch objectForKey:@"_id"];
////    
////    NSLog(@"Regular Index: %@", index);
////    NSLog(@"Regular Type: %@", type);
////    NSLog(@"Regular Score: %@", score);
////    NSLog(@"Regular Id: %@", id);
////    
////    
////    NSDictionary* fields = [bestFoodMatch objectForKey:@"fields"];
////    NSString* item_name = [fields objectForKey:@"item_name"];
////    NSString* brand_name = [fields objectForKey:@"brand_name"];
////    NSString* nf_serving_size_qty = [fields objectForKey:@"nf_serving_size_qty"];
////    
////    NSLog(@"Fields fields: %@", fields);
////    NSLog(@"Fields item_name: %@", item_name);
////    NSLog(@"Fields brand_name: %@", brand_name);
////    NSLog(@"Fields nf_servine: %@", nf_serving_size_qty);
//    
//}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [weather objectForKey:@"hits"];
    
    NSArray* listOfMatchingFoods = [weather objectForKey:@"hits"]; //2
    
    NSLog(@"List of matching foods: %@", listOfMatchingFoods);
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:indexPath.row];
    
    
    
    
    
    NSDictionary* fields = [bestFoodMatch objectForKey:@"fields"];
    NSString* item_name = [fields objectForKey:@"item_name"];

    cell.textLabel.text = item_name;
    
    
    
    NSLog(@"Im here");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray* listOfMatchingFoods = [weather objectForKey:@"hits"]; //2
    
    NSLog(@"YES BABAY");
    
    //NSLog(@"List of matching foods: %@", listOfMatchingFoods);
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:indexPath.row];
    
    
    NSString* index = [bestFoodMatch objectForKey:@"_index"];
    NSString* type = [bestFoodMatch objectForKey:@"_type"];
    NSString* score = [bestFoodMatch objectForKey:@"_score"];
    NSString* ids = [bestFoodMatch objectForKey:@"_id"];
    
    NSLog(@"Regular Index: %@", index);
    NSLog(@"Regular Type: %@", type);
    NSLog(@"Regular Score: %@", score);
    NSLog(@"Regular Id: %@", ids);
    
    
    NSDictionary* fields = [bestFoodMatch objectForKey:@"fields"];
    NSString* item_name = [fields objectForKey:@"item_name"];
    NSString* brand_name = [fields objectForKey:@"brand_name"];
    NSString* nf_serving_size_qty = [fields objectForKey:@"nf_serving_size_qty"];
    
    NSLog(@"Fields fields: %@", fields);
    NSLog(@"Fields item_name: %@", item_name);
    NSLog(@"Fields brand_name: %@", brand_name);
    NSLog(@"Fields nf_servine: %@", nf_serving_size_qty);
    
    
    NSString *string = [NSString stringWithFormat:@"https://api.nutritionix.com/v1_1/item?id=%@&appId=3ba33f4d&appKey=3b8f01ca64a3d758f3461605f13df49b", ids];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        
        NSDictionary *returnedFoodItem = (NSDictionary *)responseObject;
        
        NSLog(@"Weather Here: %@", returnedFoodItem);
        self.title = @"JSON Retrieved";
        
        //NSArray *test = [[NSArray alloc] init];
        returnedFoodItem = [returnedFoodItem objectForKey:@"nf_calories"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Here's some info!" message:[NSString stringWithFormat:@"Hey! You had 1 serving of %@? That would be %@ calories.", item_name,returnedFoodItem] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];

        
        
        
        
        //NSLog(@"Weather: %@", weather);
        //[self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];

    
    
    
    
    
    
    
    
    
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didUpdateWithFoodItem:(id)foodItem {
    itemsReturned = foodItem;
    //NSLog(@"FOOD ITEM HERE: %@", foodItem);
    //[self logItemsReturned];
}

- (void) nutritionixHTTPClient:(SMNutritionixClient *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}


- (void) logItemsReturned {
    
    NSDictionary *test = [[NSDictionary alloc] init];
    test = [itemsReturned objectForKey:@"hits"];
    
    NSArray* listOfMatchingFoods = [itemsReturned objectForKey:@"hits"]; //2
    
    
    NSDictionary* bestFoodMatch = [listOfMatchingFoods objectAtIndex:0];
    
    NSLog(@"BEST FOOD MATCH: %@", bestFoodMatch);
    
    NSString* index = [bestFoodMatch objectForKey:@"_index"];
    NSString* type = [bestFoodMatch objectForKey:@"_type"];
    NSString* score = [bestFoodMatch objectForKey:@"_score"];
    NSString* id = [bestFoodMatch objectForKey:@"_id"];
    
    NSLog(@"Regular Index: %@", index);
    NSLog(@"Regular Type: %@", type);
    NSLog(@"Regular Score: %@", score);
    NSLog(@"Regular Id: %@", id);
    
    
    NSDictionary* fields = [bestFoodMatch objectForKey:@"fields"];
    NSString* item_name = [fields objectForKey:@"item_name"];
    NSString* brand_name = [fields objectForKey:@"brand_name"];
    NSString* nf_serving_size_qty = [fields objectForKey:@"nf_serving_size_qty"];
    
    NSLog(@"Fields fields: %@", fields);
    NSLog(@"Fields item_name: %@", item_name);
    NSLog(@"Fields brand_name: %@", brand_name);
    NSLog(@"Fields nf_servine: %@", nf_serving_size_qty);
    
    
    
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}



@end
