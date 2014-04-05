//
//  ViewController.m
//  Touches
//
//  Created by Jon Manning on 13/08/13.
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        NSLog(@"A touch landed at %@", NSStringFromCGPoint([touch locationInView:touch.view]));
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        NSLog(@"A touch was moved at %@", NSStringFromCGPoint([touch locationInView:touch.view]));
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        NSLog(@"A touch ended at %@", NSStringFromCGPoint([touch locationInView:touch.view]));
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        NSLog(@"A touch was cancelled at %@", NSStringFromCGPoint([touch locationInView:touch.view]));
    }
}

@end
