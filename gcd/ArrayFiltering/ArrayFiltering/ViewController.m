//
//  ViewController.m
//  ArrayFiltering
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
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray* array = @[@"One", @"Two", @"Three", @"Four", @"Five"];

    NSLog(@"Original array: %@", array);
    
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        NSString* string = evaluatedObject;
        
        // Search for an "e" in the string
        if ([string rangeOfString:@"e"].location != NSNotFound)
            return YES;
        else
            return NO;
        
    }]];
    
    NSLog(@"Filtered array: %@", array);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
