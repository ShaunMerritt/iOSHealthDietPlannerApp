 //
//  SMMealPlanTableViewController.m
//  Elu
//
//  Created by Shaun Merritt on 9/7/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMMealPlanTableViewController.h"
#import "VENSeparatorTableViewCellProvider.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface SMMealPlanTableViewController () <VENSeparatorTableViewCellProviderDelegate, MZDayPickerDelegate, MZDayPickerDataSource>

@property (nonatomic, strong) VENSeparatorTableViewCellProvider *separatorProvider;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;


@end

@implementation SMMealPlanTableViewController
@synthesize allMeals;

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
    
    GHContextMenuView* overlay = [[GHContextMenuView alloc] init];
    overlay.dataSource = self;
    overlay.delegate = self;
    
    UILongPressGestureRecognizer* _longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:overlay action:@selector(longPressDetected:)];
    
    _longPressRecognizer.cancelsTouchesInView = NO;
    
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(80.0, 300.0, 300, 300)];
    
    [self.view addSubview:test];
    test.backgroundColor = [UIColor blackColor];
    

    
    [test addGestureRecognizer:_longPressRecognizer];
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:3 month:10 year:2013] animated:NO];

    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.separatorProvider = [[VENSeparatorTableViewCellProvider alloc] initWithStrokeColor:[UIColor grayColor]
                                                                                  fillColor:[UIColor lightGrayColor]
                                                                                   delegate:self];
    
    // Create array from all meals in the array of meals from plist:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"WeeklyDietPropertyList.plist"];
    allMeals = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath]mutableCopy];
    NSLog(@"All Meals at index 0: %@", [allMeals objectAtIndex:0]);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary = [allMeals objectAtIndex:0];
    NSLog(@"Here is my dictionary: %@", dictionary);
    
    NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
    NSLog(@"The total time is: %@ seconds", [dictionary objectForKey:@"Total Time In Seconds"]);
    
    


}

// Implementing data source methods
- (NSInteger) numberOfMenuItems
{
    return 3;
}

-(UIImage*) imageForItemAtIndex:(NSInteger)index
{
    NSString* imageName = nil;
    switch (index) {
        case 0:
            imageName = @"facebook";
            break;
        case 1:
            imageName = @"twitter";
            break;
        case 2:
            imageName = @"google-plus";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

- (void) didSelectItemAtIndex:(NSInteger)selectedIndex forMenuAtPoint:(CGPoint)point
{
    NSString* msg = nil;
    switch (selectedIndex) {
        case 0:
            msg = @"Facebook Selected";
            break;
        case 1:
            msg = @"Twitter Selected";
            break;
        case 2:
            msg = @"Google Plus Selected";
            break;
            
        default:
            break;
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
}


- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
    
    if (_dayNumber >0) {
        _dayNumber --;
    } else {
        self.dayNumber ++;
    }
    
    [self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
        
    NSLog(@"Will select day %@",day.day);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForRestOfFoods" forIndexPath:indexPath];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (_test < 4) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [allMeals objectAtIndex:_test];
        NSLog(@"Here is my dictionary: %@", dictionary);
        
        UIImageView *imageHolder = (UIImageView *)[cell viewWithTag:1];
        
        UILabel *nameOfFood = (UILabel *)[cell viewWithTag:2];
        nameOfFood.text = [dictionary objectForKey:@"Recipe Name"];
        
        NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
        
        NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"Hosted Medium URL"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UITableViewCell *weakCell = cell;
        
        [imageHolder setImageWithURLRequest:request
                           placeholderImage:placeholderImage
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                        weakCell.backgroundView = [[UIImageView alloc] initWithImage:image];
                                        
                                        [weakCell setNeedsLayout];
                                        
                                    } failure:nil];
        [self.separatorProvider applySeparatorsToCell:cell atIndexPath:indexPath inTableView:tableView cellHeight:0];
    } else {
    
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        dictionary = [allMeals objectAtIndex:_test];
        NSLog(@"Here is my dictionary: %@", dictionary);

    
    
        UIImageView *imageHolder = (UIImageView *)[cell viewWithTag:1];
        
        UILabel *nameOfFood = (UILabel *)[cell viewWithTag:2];
        nameOfFood.text = [dictionary objectForKey:@"Recipe Name"];
        
        NSLog(@"The rating is: %@ star", [dictionary objectForKey:@"Rating"]);
        
        NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"Hosted Medium URL"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        __weak UITableViewCell *weakCell = cell;
        
        [imageHolder setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.backgroundView = [[UIImageView alloc] initWithImage:image];
                                           
                                           [weakCell setNeedsLayout];
                                           
                                       } failure:nil];
        [self.separatorProvider applySeparatorsToCell:cell atIndexPath:indexPath inTableView:tableView cellHeight:0];
    }

    _test ++;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row % 7 == 4 ||indexPath.row % 5 == 2) {
//        return 44;
//    }
//    else {
        return 120;
    //}

    
}

#pragma mark - VENTableViewSeparatorProviderDelegate methods

- (BOOL)isCellJaggedAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row % 7 == 4 ||indexPath.row % 5 == 2) {
//        return YES;
//    }
//    else {
        return NO;
    //}
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

@end
