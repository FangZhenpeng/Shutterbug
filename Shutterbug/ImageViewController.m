//
//  ImageViewController.m
//  Shutterbug
//
//  Created by 方振鹏 on 13-12-11.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "ImageViewController.h"
#import "AttributedStringViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView * imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIPopoverController * urlPopover;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController


- (void) resetImage{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        [self.spinner startAnimating];
        NSURL * imageURL = self.imageURL;
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData * imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            UIImage * image = [[UIImage alloc] initWithData:imageData];
            if (self.imageURL == imageURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image) {
                        self.scrollView.zoomScale = 1;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
    }    
}

#pragma mark - Delegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Show URL"] &&
        [segue.destinationViewController isKindOfClass:[AttributedStringViewController class]]) {
        AttributedStringViewController * asc = (AttributedStringViewController *) segue.destinationViewController;
        asc.text = [[NSAttributedString alloc] initWithString:[self.imageURL description]];
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            self.urlPopover = ((UIStoryboardPopoverSegue *) segue).popoverController;
        }
        
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"Show URL"]) {
        return self.imageURL && !self.urlPopover.popoverVisible ? YES : NO;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}


#pragma mark - Getter and Setter

- (void) setTitle:(NSString *)title{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void) setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    [self resetImage];
    
}

- (UIImageView *) imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.delegate = self;
    [self resetImage];
    self.titleBarButtonItem.title = self.title;
}


@end
