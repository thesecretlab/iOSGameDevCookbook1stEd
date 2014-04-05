//
//  ViewController.m
//  ImageAnimation
//
//  Created by Jon Manning on 23/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
       
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:2.0 animations:^{
        self.ball.center = CGPointMake(0, 0);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
