//
//  ViewController.m
//  DelayedBlock
//
//  Created by Jon Manning on 5/06/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"About to do a delayed block..");
	
    double timeToWait = 1.0;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeToWait * NSEC_PER_SEC));
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_after(delayTime, queue, ^(void){
        NSLog(@"Delayed block");
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
