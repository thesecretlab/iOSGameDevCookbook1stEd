//
//  ViewController.m
//  UserLocation
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
}

@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationErrorLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    self.locationErrorLabel.hidden = YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.locationErrorLabel.hidden = YES;
    
    CLLocation* location = [locations lastObject];
    
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %.4f", latitude];
    self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %.4f", longitude];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationErrorLabel.hidden = NO;
}

@end
