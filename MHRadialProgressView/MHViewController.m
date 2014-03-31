//
//  MHViewController.m
//  MHRadialProgressView
//
//  Created by Mehfuz Hossain on 3/24/14.
//  Copyright (c) 2014 Mehuz Hossain. All rights reserved.
//

#import "MHViewController.h"
#import "MHRadialProgressView.h"

@interface MHViewController ()

@property MHRadialProgressView *progressView;

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:60/255. green:60/255. blue:60/255. alpha:1.0]];

    self.progressView = [[MHRadialProgressView alloc] initWithFrame:CGRectMake(0, 0, 150, 150) points:@[@5, @10, @2, @9]];
    
    self.progressView.center = self.view.center;
    
    [self.view addSubview:self.progressView];
    
    UILabel *summaryLabel = [[UILabel alloc] init];
    
    [summaryLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [summaryLabel setText:@"Tap to Increase"];
    
    [summaryLabel setFrame:CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, summaryLabel.font.pointSize)];
    
    [summaryLabel setTextAlignment:NSTextAlignmentCenter];
    
    [summaryLabel setTextColor:[UIColor whiteColor]];
    
    [self.view addSubview:summaryLabel];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    [self.progressView addGestureRecognizer:tapGestureRecognizer];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
   [self.progressView moveNext];
}

- (void)tapped:(UITapGestureRecognizer*)gesture
{
    [self.progressView moveNext];
}

@end
