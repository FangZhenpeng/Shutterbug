//
//  AttributedStringViewController.m
//  Shutterbug
//
//  Created by 方振鹏 on 13-12-12.
//  Copyright (c) 2013年 方振鹏. All rights reserved.
//

#import "AttributedStringViewController.h"

@interface AttributedStringViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AttributedStringViewController


#pragma mark - Setter and Getter

- (void) setText:(NSAttributedString *)text{
    _text = text;
    self.textView.attributedText = text;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textView.attributedText = self.text;
}


@end
