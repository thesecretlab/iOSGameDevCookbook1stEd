//
//  ViewController.m
//  Blocks
//
//  Created by Jon Manning on 5/06/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

// A block type
typedef void(^ExampleBlock)(void);

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Defining a block using the full syntax
    void(^MyBlock)(void);
    
    MyBlock = ^(void) {
        NSLog(@"Hello from the block!");
    };
    
    MyBlock();
    
    // Defining a block using the block type defined above
    ExampleBlock aBlock = ^(void) {
        NSLog(@"Hey there!");
    };
    
    aBlock();
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
