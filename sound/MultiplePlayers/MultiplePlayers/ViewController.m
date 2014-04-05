//
//  ViewController.m
//  MultiplePlayers
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import "AVAudioPlayerPool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)playSound1:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"TestSound" withExtension:@"wav"];
    AVAudioPlayer* player = [AVAudioPlayerPool playerWithURL:url];
    [player play];
}

- (IBAction)playSound2:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"SendMessage" withExtension:@"aif"];
    AVAudioPlayer* player = [AVAudioPlayerPool playerWithURL:url];
    [player play];

}

- (IBAction)playSound3:(id)sender {
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"ReceiveMessage" withExtension:@"aif"];
    AVAudioPlayer* player = [AVAudioPlayerPool playerWithURL:url];
    [player play];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
