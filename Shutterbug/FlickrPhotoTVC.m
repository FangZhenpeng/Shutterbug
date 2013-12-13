//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by 方振鹏 on 13-12-11.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"

@interface FlickrPhotoTVC () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotoTVC

- (void) setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSString *) titleForRow:(unsigned int) row{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}


- (NSString *) subTitleForRow:(unsigned int) row{
    return [self.photos[row][FLICKR_PHOTO_OWNER] description];
}


#pragma mark - Delegate

- (void) awakeFromNib{
    self.splitViewController.delegate = self;
}

- (BOOL) splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"] &&
                [segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                NSURL * url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
            }
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subTitleForRow:indexPath.row];
    
    return cell;
}

@end
