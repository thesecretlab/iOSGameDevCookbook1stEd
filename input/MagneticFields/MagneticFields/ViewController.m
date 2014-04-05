//
//  ViewController.m
//  MagneticFields
//
//  Created by Jon Manning on 13/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@import CoreMotion;

@interface ViewController () {
    CMMotionManager* motionManager;
}

@property (strong, nonatomic) IBOutlet UILabel *magneticFieldXLabel;
@property (strong, nonatomic) IBOutlet UILabel *magneticFieldYLabel;
@property (strong, nonatomic) IBOutlet UILabel *magneticFieldZLabel;
@property (weak, nonatomic) IBOutlet UILabel *magneticFieldAverageLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    motionManager = [[CMMotionManager alloc] init];
    
    [motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
        
        CMMagneticField magneticField = magnetometerData.magneticField;
        
        NSString* xValue = [NSString stringWithFormat:@"%.2f", magneticField.x];
        NSString* yValue = [NSString stringWithFormat:@"%.2f", magneticField.y];
        NSString* zValue = [NSString stringWithFormat:@"%.2f", magneticField.z];
        
        double average = (magneticField.x + magneticField.y + magneticField.z) / 3.0;
        
        NSString* averageValue = [NSString stringWithFormat:@"%.2f", average];
        
        self.magneticFieldXLabel.text = xValue;
        self.magneticFieldYLabel.text = yValue;
        self.magneticFieldZLabel.text = zValue;
        self.magneticFieldAverageLabel.text = averageValue;
        

    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
