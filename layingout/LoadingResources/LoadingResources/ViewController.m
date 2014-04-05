//
//  ViewController.m
//  LoadingResources
//
//  Created by Jon Manning on 22/10/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray* imagesToLoad = [NSArray array];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    for (NSString* imageFileName in imagesToLoad) {
        dispatch_group_async(group, backgroundQueue, ^{
            // Load the file
        });
    }
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_group_notify(group, mainQueue, ^{
        // All images are done loading at this point
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
