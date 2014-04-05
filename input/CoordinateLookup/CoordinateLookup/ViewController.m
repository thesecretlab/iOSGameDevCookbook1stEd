//
//  ViewController.m
//  CoordinateLookup
//
//  Created by Jon Manning on 18/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () {
    CLGeocoder* geocoder;
}

@property (strong, nonatomic) IBOutlet UITextView *addressTextView;

@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    geocoder = [[CLGeocoder alloc] init];
}

- (IBAction)performLookup:(id)sender {
    
    // Cancel any existing geocode operation
    [geocoder cancelGeocode];
    
    [self.addressTextView resignFirstResponder];
    
    NSString* addressString = self.addressTextView.text;
    
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
       
        if (error) {
            self.latitudeLabel.text = @"Error!";
            self.longitudeLabel.text = @"Error!";
        } else {
            CLPlacemark* placemark = [placemarks lastObject];
            
            float latitude = placemark.location.coordinate.latitude;
            float longitude = placemark.location.coordinate.longitude;
            
            self.latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %.4f", latitude];
            
            self.longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %.4f", longitude];
            
        }
        
    }];
}

@end
