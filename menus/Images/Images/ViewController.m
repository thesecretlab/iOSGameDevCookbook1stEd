//
//  ViewController.m
//  Images
//
//  Created by Jon Manning on 5/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [self.view addSubview:imageView];
    
    UIImage* image = [UIImage imageNamed:@"Kitten"];
    
    [imageView setImage:image];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
