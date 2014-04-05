//
//  ViewController.m
//  InterfaceTheming
//
//  Created by Jon Manning on 24/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [[UIProgressView appearance] setTrackTintColor:[UIColor redColor]];
    [[UIProgressView appearance] setProgressTintColor:[UIColor orangeColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
