//
//  ViewController.m
//  ImageStretching
//
//  Created by Jon Manning on 24/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage* originalImage = [UIImage imageNamed:@"StretchableImage.png"];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 45, 0, 45);
    
    UIImage* stretchableImage = [originalImage resizableImageWithCapInsets:edgeInsets];
    
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    self.imageView.image = stretchableImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
