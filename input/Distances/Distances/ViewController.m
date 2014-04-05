//
//  ViewController.m
//  Distances
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    CLCircularRegion* regionToMonitor;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (regionToMonitor == nil) {
        
        CLLocation* location = [locations lastObject];
        
        regionToMonitor = [[CLCircularRegion alloc] initWithCenter:location.coordinate radius:20 identifier:@"StartingPoint"];
        
        [locationManager startMonitoringForRegion:regionToMonitor];
        
        NSLog(@"Now monitoring region %@", regionToMonitor);
        
    }
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entering region!");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exiting region!");
}


@end
