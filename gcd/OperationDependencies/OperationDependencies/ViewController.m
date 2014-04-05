//
//  ViewController.m
//  OperationDependencies
//
//  Created by Jon Manning on 6/06/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSBlockOperation* firstOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"First operation");
    }];
    
    NSBlockOperation* secondOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Second operation (depends on third operation and first operation)");
    }];
    
    
    NSBlockOperation* thirdOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Third operation");
    }];
    
    [secondOperation addDependency:thirdOperation];
    [secondOperation addDependency:firstOperation];
    
    [[NSOperationQueue mainQueue] addOperations:@[firstOperation, secondOperation, thirdOperation] waitUntilFinished:NO];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
