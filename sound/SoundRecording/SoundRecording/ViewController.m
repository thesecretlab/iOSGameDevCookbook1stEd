//
//  ViewController.m
//  SoundRecording
//
//  Created by Jon Manning on 30/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    AVAudioRecorder* audioRecorder;
    AVAudioPlayer* audioPlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL* destinationURL = [self audioRecordingURL];
    NSError* error;
    
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:destinationURL settings:nil error:&error];
    
    if (error != nil) {
        NSLog(@"Couldn't create a recorder: %@", [error localizedDescription]);
    }
    
    [audioRecorder prepareToRecord];
}

- (NSURL*) audioRecordingURL {
    NSURL* documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    return [documentsURL URLByAppendingPathComponent:@"RecordedSound.wav"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRecording:(UIButton*)sender {
    if (audioRecorder.recording) {
        [audioRecorder stop];
        [sender setTitle:@"Start Recording" forState:UIControlStateNormal];
    } else {
        [audioRecorder record];
        [sender setTitle:@"Stop Recording" forState:UIControlStateNormal];
    }
}


- (IBAction)playRecording:(id)sender {
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self audioRecordingURL] error:nil];
    
    [audioPlayer play];
    
}
@end
