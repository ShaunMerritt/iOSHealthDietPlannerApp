//
//  SMLikeFoodsTableViewController.m
//  Elu
//
//  Created by Shaun Merritt on 7/1/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMLikeFoodsTableViewController.h"
#import "SMLikesFoodTableViewCell.h"
#import "SMFood.h"
#import <CoreGraphics/CoreGraphics.h>
#import "ImageFilter.h"


@interface SMLikeFoodsTableViewController ()

@end

@implementation SMLikeFoodsTableViewController 

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
    
    _foods = [NSMutableArray arrayWithCapacity:20];
    
    SMFood *food = [[SMFood alloc] init];
    food.name = @"Bill Evans";
    food.image = 1;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Oscar Peterson";
    food.image = 2;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 3;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 4;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 5;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 1;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 2;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 3;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 4;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 5;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 1;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 2;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 3;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 4;
    [_foods addObject:food];
    
    food = [[SMFood alloc] init];
    food.name = @"Dave Brubeck";
    food.image = 5;
    [_foods addObject:food];
    
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"here");
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
    return [self.foods count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SMLikesFoodTableViewCell *cell = (SMLikesFoodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    SMFood *food = (self.foods)[indexPath.row];
    cell.foodLabel.text = food.name;
    
    cell.backgroundImageFood.image = [self imageForRating:food.image];
    
    
    
    return cell;
    
    
    
    
    
    
    
    
    
    
        // = 1.3 * cell.backgroundView.frame.size.height;
    //cell.backgroundView =[UIView alloc]  [self imageForRating:food.image];
    //cell.backgroundImage.image = [cell.backgroundImage.image blackAndWhite];
    
    /*
    UIImageView *bgView = [[UIImageView alloc] init]; // Creating a view for the background...this seems to be required.
    bgView.backgroundColor = [UIColor redColor];
    cell.backgroundView = bgView;
    
    UIImageView *bgImageView = [[UIImageView alloc] init]; // Creating a subview for the background...
    bgImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [bgImageView setFrame:CGRectInset(cell.bounds, -10, -10)];
    
    [cell.backgroundView addSubview:bgImageView]; // Assigning the subview, and cleanup.
    */
    
   /* UIImageView * ac= [[UIImageView alloc] init];
    ac.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hi.png"]];
    cell.backgroundView =ac;
    CGRect frame = CGRectMake(cell.backgroundView.frame.origin.x, 300, cell.backgroundView.frame.size.width, 130);
    cell.backgroundView.frame = frame;
    cell.backgroundColor = [UIColor whiteColor];
    */
    //cell.backgroundImageFood.image = [UIImage imageNamed:@"testImage"];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"hi.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    //return cell;
}


/*
- (UIImage *)imageBlackAndWhite
{
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}
 */

- (UIImage *)imageForRating:(int)image
{
    switch (image) {
        case 1: return [UIImage imageNamed:@"chickenBW"];
        case 2: return [UIImage imageNamed:@"eggsBW"];
        case 3: return [UIImage imageNamed:@"fishBW"];
        case 4: return [UIImage imageNamed:@"fruitBW"];
        case 5: return [UIImage imageNamed:@"vegetablesBW"];
    }
    return nil;
}


- (UIImage *)imageForTap:(int)image
{
    switch (image) {
        case 1: return [UIImage imageNamed:@"chicken"];
        case 2: return [UIImage imageNamed:@"egg"];
        case 3: return [UIImage imageNamed:@"salmon"];
        case 4: return [UIImage imageNamed:@"fruit"];
        case 5: return [UIImage imageNamed:@"vegetables"];
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //UITableViewCell *cell        = [tableView cellForRowAtIndexPath:indexPath];
    
    
    SMFood *food = (self.foods)[indexPath.row];
    
    
    SMLikesFoodTableViewCell *cell = (SMLikesFoodTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundImageFood.image = [self imageForTap:food.image];
    cell.accessoryType           = UITableViewCellAccessoryCheckmark;

    
    //self.cell.backgroundImage.image = [self imageForRating:food.image];
    //self.cell.backgroundImage.image.filter = nil;

}





/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)activeScrollView {
    //logic here
    NSLog(@"begin");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float offset = self.tableViewForFoods.contentOffset.y / self.tableViewForFoods.frame.size.height;
    NSLog(@"is the background!!!!!");
    
    for (int i = 0; i <[self.foods count]; i++) {
        SMLikesFoodTableViewCell *cell = (SMLikesFoodTableViewCell *)[self.tableViewForFoods dequeueReusableCellWithIdentifier:@"cell"];
        
        CGRect frame = CGRectMake(cell.backgroundView.frame.origin.x, offset * 50, cell.backgroundView.frame.size.width, cell.backgroundImage.frame.size.height);
        cell.backgroundView.frame = frame;
        NSLog(@"is the background");
    }
}

-(void)scrollTable:(UIScrollView *)scrollView
{
    float offset = self.tableView.contentOffset.y / self.tableView.frame.size.height;
    NSLog(@"is the background!!!!!");

    for (int i = 0; i <[self.foods count]; i++) {
        SMLikesFoodTableViewCell *cell = (SMLikesFoodTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        CGRect frame = CGRectMake(cell.backgroundView.frame.origin.x, offset * 50, cell.backgroundView.frame.size.width, cell.backgroundView.frame.size.height);
        cell.backgroundView.frame = frame;
        NSLog(@"is the background");
    }
}
*/

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
