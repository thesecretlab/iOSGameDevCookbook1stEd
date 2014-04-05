//
//  ViewController.m
//  Speech
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
}


@property (strong) AVSpeechSynthesizer* speechSynthesizer;
@property (strong, nonatomic) IBOutlet UITextField *textToSpeakField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)speakText:(id)sender {
    AVSpeechUtterance* utterance = [AVSpeechUtterance speechUtteranceWithString:self.textToSpeakField.text];
    
    [self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    
    [self.speechSynthesizer speakUtterance:utterance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
