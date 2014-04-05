//
//  ViewController.m
//  FacebookSheet
//
//  Created by pba on 12/08/13.
//  Copyright (c) 2013 Secret Lab Pty. Ltd. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

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

- (IBAction)postToFacebookTapped:(id)sender {
    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookSheet setInitialText:@"My high score was legendary!"];
    [self presentViewController:facebookSheet animated:YES completion:nil];
}

- (IBAction)postToFacebookWithImageTapped:(id)sender {
    SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookSheet setInitialText:@"Check out my character!"];
    [facebookSheet addImage:[UIImage imageNamed:@"Apollo"]];
    [facebookSheet addURL:[NSURL URLWithString:@"http://www.secretlab.com.au"]];
    [self presentViewController:facebookSheet animated:YES completion:nil];
}
@end
