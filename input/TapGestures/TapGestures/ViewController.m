//
//  ViewController.m
//  TapGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *tapView;
@property (strong, nonatomic) IBOutlet UILabel *tapCountLabel;

@property (assign) NSUInteger tapCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    [self.tapView addGestureRecognizer:tap];
}

- (void) tapped:(UITapGestureRecognizer*)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        self.tapCount++;
        
        self.tapCountLabel.text = [NSString stringWithFormat:@"It's been tapped %i times!", self.tapCount];
    }
}

@end
