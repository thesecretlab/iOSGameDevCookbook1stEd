//
//  ViewController.h
//  SoundRecording
//
//  Created by Jon Manning on 30/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)startRecording:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
- (IBAction)playRecording:(id)sender;
@end
