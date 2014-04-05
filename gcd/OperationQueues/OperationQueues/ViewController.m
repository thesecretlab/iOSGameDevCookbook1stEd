//
//  ViewController.m
//  OperationQueues
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
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        NSLog(@"Main queue block #1");
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        NSLog(@"Main queue block #2");
    }];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        NSLog(@"Main queue block #3");
    }];
    
    NSOperationQueue* concurrentQueue = [[NSOperationQueue alloc] init];
    concurrentQueue.maxConcurrentOperationCount = 10;
    
    [concurrentQueue addOperationWithBlock:^{
        NSLog(@"Concurrent queue block #1");
    }];
    
    [concurrentQueue addOperationWithBlock:^{
        NSLog(@"Concurrent queue block #2");
    }];

    [concurrentQueue addOperationWithBlock:^{
        NSLog(@"Concurrent queue block #3");
    }];

    
    NSLog(@"Done adding operations");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
