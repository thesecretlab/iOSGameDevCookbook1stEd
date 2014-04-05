//
//  ViewController.m
//  Updating
//
//  Created by Jon Manning on 17/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    CADisplayLink* displayLink;
    
    NSTimer* timer;
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the CADisplayLink; 'self' will receive the updateWithDisplayLink: message every
    // time the screen updates
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWithDisplayLink:)];
    
    // Add the display link and start receiving updates
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    // Pause the display link
    displayLink.paused = YES;
    
    // Remove the display link
    [displayLink invalidate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateWithTimer:) userInfo:nil repeats:YES];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) updateWithDisplayLink:(CADisplayLink*)displayLink {
    // The screen's just updated; update the game
    NSLog(@"Updated from display link!");
}

- (void) updateWithTimer:(NSTimer*) timer {
    // The timer's gone off; update the game
    NSLog(@"Updated from timer!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
