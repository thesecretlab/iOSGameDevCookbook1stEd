//
//  ViewController.m
//  Dynamics
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;

@property (strong) UIDynamicAnimator* animator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSArray* buttonsArray  =@[self.button1, self.button2, self.button3];
    
    UIGravityBehavior* gravity = [[UIGravityBehavior alloc] initWithItems:buttonsArray];
    
    [self.animator addBehavior:gravity];
    
 
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:buttonsArray];

    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    //[collision setTranslatesReferenceBoundsIntoBoundary:YES];

    [self.animator addBehavior:collision];
    
    
    UIAttachmentBehavior* attachment = [[UIAttachmentBehavior alloc] initWithItem:self.button1 attachedToAnchor:CGPointZero];
    
    [[UIAttachmentBehavior alloc] initWithItem:animatedButton attachedToItem:anotherView];
    
    
    [self.animator addBehavior:attachment];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
