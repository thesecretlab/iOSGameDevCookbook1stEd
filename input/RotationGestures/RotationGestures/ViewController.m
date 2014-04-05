//
//  ViewController.m
//  RotationGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *rotationView;
@property (strong, nonatomic) IBOutlet UILabel *rotationStatusLabel;
@property (assign) float angle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRotationGestureRecognizer* rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotated:)];
    
    [self.rotationView addGestureRecognizer:rotation];
    
}

- (void) rotated:(UIRotationGestureRecognizer*)rotation {
    if (rotation.state == UIGestureRecognizerStateBegan) {
        self.rotationStatusLabel.text = @"Rotation started";
    }
    if (rotation.state == UIGestureRecognizerStateChanged) {
        self.angle += [rotation rotation];
        rotation.rotation = 0.0;
        self.rotationView.transform = CGAffineTransformMakeRotation(self.angle);
        self.rotationStatusLabel.text = [NSString stringWithFormat:@"Rotation: %.2f radians", self.angle];
    }
    if (rotation.state == UIGestureRecognizerStateEnded) {
        self.rotationStatusLabel.text = @"Rotation ended";
    }
    if (rotation.state == UIGestureRecognizerStateCancelled) {
        self.rotationStatusLabel.text = @"Rotation cancelled";
    }
}

@end
