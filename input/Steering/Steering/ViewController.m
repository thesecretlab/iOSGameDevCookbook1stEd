//
//  ViewController.m
//  Steering
//
//  Created by Jon Manning on 13/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@import CoreMotion;

@interface ViewController () {
    CMMotionManager* motionManager;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    motionManager = [[CMMotionManager alloc] init];
    
    [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        // Maximum steering left is -50 degrees, maximum steering right is 50 degrees
        float maximumSteerAngle = 50;
        
        // When in landscape,
        float rotationAngle = motion.attitude.pitch * 180.0f / M_PI;
        
        // -1.0 = hard left, 1.0 = hard right
        float steering = 0.0;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            steering = rotationAngle / -maximumSteerAngle;
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            steering = rotationAngle / maximumSteerAngle;
        }
        
        // Limit the steering to between -1.0 and 1.0
        steering = fminf(steering, 1.0);
        steering = fmaxf(steering, -1.0);
        
        NSLog(@"Steering: %.2f", steering);
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
