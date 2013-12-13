//
//  LatestFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by 方振鹏 on 13-12-12.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "LatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface LatestFlickrPhotosTVC ()

@end

@implementation LatestFlickrPhotosTVC

- (void) loadLatestPhotosFromFlickr{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr latest loader", NULL);
    dispatch_async(loaderQ, ^{
        NSArray * latestPhotos = [FlickrFetcher latestGeoreferencedPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadLatestPhotosFromFlickr];
    [self.refreshControl addTarget:self action:@selector(loadLatestPhotosFromFlickr) forControlEvents:UIControlEventValueChanged];
}

@end
