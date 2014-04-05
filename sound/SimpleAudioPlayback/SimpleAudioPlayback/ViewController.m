//
//  ViewController.m
//  SimpleAudioPlayback
//
//  Created by Jon Manning on 30/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    AVAudioPlayer* audioPlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSURL* soundFileURL = [[NSBundle mainBundle] URLForResource:@"TestSound" withExtension:@"wav"];
    NSError* error = nil;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    
    if (error != nil) {
        NSLog(@"Failed to load the sound: %@", [error localizedDescription]);
    }
    
    [audioPlayer prepareToPlay];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSound:(id)sender {
    
    [audioPlayer play];
    
}

- (IBAction)loopModeChanged:(id)sender {
    
    UISwitch* loopSwitch = sender;
    
    if (loopSwitch.on == YES)
        audioPlayer.numberOfLoops = -1;
    else if (loopSwitch.on == NO)
        audioPlayer.numberOfLoops = 0;
        
    
}
@end
