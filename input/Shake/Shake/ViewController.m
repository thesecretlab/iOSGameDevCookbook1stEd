//
//  ViewController.m
//  Shake
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *shakingLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.shakingLabel.hidden = YES;
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    self.shakingLabel.hidden = NO;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.shakingLabel.hidden = YES;
    });
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
