//
//  MyScene.m
//  ScreenShaking
//
//  Created by Jon Manning on 12/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    SKNode* cameraNode;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        cameraNode = [SKNode node];
        [self addChild:cameraNode];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [cameraNode addChild:myLabel];
    }
    return self;
}

- (void) shakeNode:(SKNode*)node {
    // Reset the camera's position
    node.position = CGPointZero;
    
    // Cancel any existing shake actions
    [node removeActionForKey:@"shake"];
    
    // The number of individual movements that the shake will be made up of
    int shakeSteps = 15;
    
    // How "big" the shake is
    float shakeDistance = 20;
    
    // How long the shake should go for
    float shakeDuration = 0.25;
    
    // An array to store the individual movements in
    NSMutableArray* shakeActions = [NSMutableArray array];
    
    // Start at shakeSteps, and step down to 0
    for (int i = shakeSteps; i > 0; i--) {
        
        // How long this specific shake movement will take
        float shakeMovementDuration = shakeDuration / shakeSteps;
        
        // At the start, this will be equal to 1.0, and gradually move down to 0.0
        float shakeAmount= i / (float)shakeSteps;
        
        // Take the current position - we'll then add an offset from that
        CGPoint shakePosition = node.position;
        
        // Pick a random amount from -shakeDistance to shakeDistance
        shakePosition.x += (arc4random_uniform(shakeDistance*2) - shakeDistance) * shakeAmount;
        shakePosition.y += (arc4random_uniform(shakeDistance*2) - shakeDistance) * shakeAmount;
        
        // Create the action that moves the node to the new location, and add it to the list
        SKAction* shakeMovementAction = [SKAction moveTo:shakePosition duration:shakeMovementDuration];
        [shakeActions addObject:shakeMovementAction];
        
    }
    
    // Run the shake!
    SKAction* shakeSequence = [SKAction sequence:shakeActions];
    [node runAction:shakeSequence withKey:@"shake"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self shakeNode:cameraNode];
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
