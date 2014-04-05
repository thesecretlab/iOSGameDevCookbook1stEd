//
//  ViewController.m
//  CustomGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import "DownUpGestureRecognizer.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *customGestureView;
@property (strong, nonatomic) IBOutlet UILabel *customGestureStatusLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DownUpGestureRecognizer* downUpGesture = [[DownUpGestureRecognizer alloc] initWithTarget:self action:@selector(downUp:)];
    
    [self.customGestureView addGestureRecognizer:downUpGesture];
}

- (void) downUp:(DownUpGestureRecognizer*)downUp {
    
    if (downUp.state == UIGestureRecognizerStateBegan) {
        self.customGestureStatusLabel.text = @"Gesture began";
    }
    
    if (downUp.state == UIGestureRecognizerStateChanged) {
        NSString* phaseString;
        if (downUp.phase == DownUpGestureMovingDown)
            phaseString = @"Down";
        
        if (downUp.phase == DownUpGestureMovingUp)
            phaseString = @"Up";
        
        self.customGestureStatusLabel.text = [NSString stringWithFormat:@"Gesture changed, phase = %@", phaseString];
    }
    
    if (downUp.state == UIGestureRecognizerStateEnded) {
        self.customGestureStatusLabel.text = @"Gesture ended";
    }
    
    if (downUp.state == UIGestureRecognizerStateCancelled) {
        self.customGestureStatusLabel.text = @"Gesture cancelled";
    }
    
    if (downUp.state == UIGestureRecognizerStateFailed) {
        self.customGestureStatusLabel.text = @"Gesture failed";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
