//
//  ViewController.m
//  Speed
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
}

@property (strong, nonatomic) IBOutlet UILabel *speedLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [locationManager startUpdatingLocation];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* lastLocation = [locations lastObject];
    
    if (lastLocation.speed > 0) {
        self.speedLabel.text = [NSString stringWithFormat:@"Currently moving at %.0fms", lastLocation.speed];
        
    }
    
}

@end
