//
//  ViewController.m
//  Dragging
//
//  Created by Jon Manning on 23/03/13.
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

- (void) viewWillAppear:(BOOL)animated {
    self.draggedView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer* drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
    [self.draggedView addGestureRecognizer:drag];
}

- (void) drag:(UIPanGestureRecognizer*)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint newPosition = [pan translationInView:pan.view];
        newPosition.x += pan.view.center.x;
        newPosition.y += pan.view.center.y;
        
        pan.view.center = newPosition;
        
        [pan setTranslation:CGPointZero inView:pan.view];        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
