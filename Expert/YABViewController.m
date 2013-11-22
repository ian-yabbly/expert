//
//  YABViewController.m
//  Expert
//
//  Created by Ian Shafer on 11/19/13.
//  Copyright (c) 2013 Yabbly. All rights reserved.
//

#import "YABViewController.h"
#import "YABStartView.h"

@interface YABViewController ()

@end

@implementation YABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _startView = [[YABStartView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_startView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
