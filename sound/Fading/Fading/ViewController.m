//
//  ViewController.m
//  Fading
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (strong) AVAudioPlayer* audioPlayer;

@end

@implementation ViewController

- (IBAction)fadeIn:(id)sender {
    
    [self fadePlayer:self.audioPlayer fromVolume:0.0 toVolume:1.0 overTime:1.0];
    
    
}

- (IBAction)fadeOut:(id)sender {
    [self fadePlayer:self.audioPlayer fromVolume:1.0 toVolume:0.0 overTime:1.0];
}

- (void) fadePlayer:(AVAudioPlayer*)player fromVolume:(float)startVolume toVolume:(float)endVolume overTime:(float)time {
    
    // Update the volume every 1/100 of a second
    float fadeSteps = time * 100.0;
    
    self.audioPlayer.volume = startVolume;
    
    for (int step = 0; step < fadeSteps; step++) {
        double delayInSeconds = step * (time / fadeSteps);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            float fraction = ((float)step / fadeSteps);
            
            self.audioPlayer.volume = startVolume + (endVolume - startVolume) * fraction;
            
        });
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // You'll need to provide your own music file here:
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"MyMusic" withExtension:@"m4a"];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.audioPlayer.numberOfLoops = -1;
    
    self.audioPlayer.volume = 1.0;
    
    [self.audioPlayer play];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
