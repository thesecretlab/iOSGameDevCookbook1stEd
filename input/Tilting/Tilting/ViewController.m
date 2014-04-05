//
//  ViewController.m
//  Tilting
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () {
    CMMotionManager* motionManager;
}

@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet UILabel *yawLabel;
@property (strong, nonatomic) IBOutlet UILabel *rollLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    
    [motionManager startDeviceMotionUpdatesToQueue:mainQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        float roll = motion.attitude.roll;
        float rollDegrees = roll * 180 / M_PI;
        
        float yaw = motion.attitude.yaw;
        float yawDegrees = yaw * 180 / M_PI;
        
        float pitch = motion.attitude.pitch;
        float pitchDegrees = pitch * 180 / M_PI;
        
        
        self.rollLabel.text = [NSString stringWithFormat:@"Roll: %.2f°", rollDegrees];
        self.yawLabel.text = [NSString stringWithFormat:@"Yaw: %.2f°", yawDegrees];
        self.pitchLabel.text = [NSString stringWithFormat:@"Pitch: %.2f°", pitchDegrees];
        
        
        
        
    }];
}

@end
