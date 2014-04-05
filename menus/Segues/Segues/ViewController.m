//
//  ViewController.m
//  Segues
//
//  Created by Jon Manning on 2/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)closePopup:(UIStoryboardSegue*)segue {
    NSLog(@"Returning from the popup view controller");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"About to perform the %@ segue", segue.identifier);
}

- (IBAction)showPopup:(id)sender {
    [self performSegueWithIdentifier:@"ShowPopup" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
