//
//  ViewController.m
//  BlockTimer
//
//  Created by Jon Manning on 6/06/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    dispatch_source_t timer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    
    __block int count = 0;
    
    dispatch_source_set_event_handler(timer, ^{
        count ++;
        
        if (count > 5)
            [self cancelTimer];
        
        NSLog(@"Hello from the timer!");
    });
    
    dispatch_resume(timer);
    
}

- (void) cancelTimer {
    timer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
