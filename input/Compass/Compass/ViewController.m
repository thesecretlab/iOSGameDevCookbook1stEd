//
//  ViewController.m
//  Compass
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () {
    CMMotionManager* motionManager;
}
@property (strong, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    
    [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:mainQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        float yaw = motion.attitude.yaw;
        
        float yawDegrees = yaw * 180 / M_PI;
        
        self.directionLabel.text = [NSString stringWithFormat:@"Direction: %.0f°", yawDegrees];
        
    }];
}


@end
