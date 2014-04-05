//
//  ViewController.m
//  AddressLookup
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    CLGeocoder* geocoder;
}

@property (strong, nonatomic) IBOutlet UITextView *labelTextView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.distanceFilter = 100;
    
    [locationManager startUpdatingLocation];
    
    geocoder = [[CLGeocoder alloc] init];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = [locations lastObject];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSString* addressString = [placemarks componentsJoinedByString:@";"];
        
        self.labelTextView.text = addressString;
        
    }];
    
}

@end
