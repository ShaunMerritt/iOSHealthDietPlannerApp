//
//  SMDoctorPatientsTableViewController.m
//  Elu
//
//  Created by Shaun Merritt on 6/24/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMDoctorPatientsTableViewController.h"
#import "SMEditPatientDietViewController.h"

@interface SMDoctorPatientsTableViewController ()

@end

@implementation SMDoctorPatientsTableViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.navigationItem.hidesBackButton = YES;
    
    // Use this code to show ALL created patients under doctor
    PFQuery *query = [PFUser query];
    [query whereKey:@"doctorIdentifier" containsString:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers = objects;
            [self.tableView reloadData];
            NSLog(@"test");
        }
    }];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    //Use this for ALL:
    return [self.allUsers count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Use for ALL:
    PFUser *user        = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    //Use for relations
    //PFUser *user = [self.patients objectAtIndex:indexPath.row];
    //cell.textLabel.text = user.username;
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addPatient"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        NSLog(@"TEST");
    }
    
    if ([[segue identifier] isEqualToString:@"pushedOnCell"]) {
        
        NSLog(@"here");
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
        NSString *userName = user.username;
        [[segue destinationViewController] setDetailItem:userName];
        
   }
    
}


@end
