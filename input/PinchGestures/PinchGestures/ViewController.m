//
//  ViewController.m
//  PinchGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *scalingView;
@property (strong, nonatomic) IBOutlet UILabel *scalingStatusLabel;
@property (assign) float scale;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scale = 1;
    
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinched:)];
    
    [self.scalingView addGestureRecognizer:pinch];
    
}

- (void) pinched:(UIPinchGestureRecognizer*)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        self.scalingStatusLabel.text = @"Pinch started";
    }
    if (pinch.state == UIGestureRecognizerStateChanged) {
        self.scale *= pinch.scale;
        pinch.scale = 1.0;
        self.scalingView.transform = CGAffineTransformMakeScale(self.scale, self.scale);
        self.scalingStatusLabel.text = [NSString stringWithFormat:@"Scale: %.2f%%", self.scale*100];
    }
    if (pinch.state == UIGestureRecognizerStateEnded) {
        self.scalingStatusLabel.text = @"Pinch ended";
    }
    if (pinch.state == UIGestureRecognizerStateCancelled) {
        self.scalingStatusLabel.text = @"Pinch cancelled";
    }
}

@end
