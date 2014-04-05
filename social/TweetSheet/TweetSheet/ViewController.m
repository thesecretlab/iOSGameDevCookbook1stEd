//
//  ViewController.m
//  TweetSheet
//
//  Created by pba on 12/08/13.
//  Copyright (c) 2013 Secret Lab Pty. Ltd. All rights reserved.
//

#import "ViewController.h"

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

- (IBAction)sendTweetButtonTapped:(id)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"My high score was legendary!"];
    [self presentViewController:tweetSheet animated:YES completion:Nil];
}

- (IBAction)sendTweetWithImageButtonTapped:(id)sender {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"Check out my character!"];
    [tweetSheet addImage:[UIImage imageNamed:@"Apollo"]];
    [tweetSheet addURL:[NSURL URLWithString:@"http://www.secretlab.com.au"]];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (IBAction)checkButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"Twitter is available!"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"Twitter is not available!"
                                  delegate:self
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }

}
@end
