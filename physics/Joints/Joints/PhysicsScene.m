//
//  MyScene.m
//  Joints
//
//  Created by Jon Manning on 19/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

@implementation PhysicsScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKSpriteNode* anchor = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 100)];
        anchor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        anchor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:anchor.size];
        anchor.physicsBody.dynamic = NO;
        
        [self addChild:anchor];
        
        SKSpriteNode* attachment = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(100, 100)];
        attachment.position = CGPointMake(CGRectGetMidX(self.frame) + 100, CGRectGetMidY(self.frame) - 100);
        attachment.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:attachment.size];
        
        [self addChild:attachment];
        
        SKPhysicsJointPin* pinJoint = [SKPhysicsJointPin jointWithBodyA:anchor.physicsBody bodyB:attachment.physicsBody anchor:anchor.position];
        
        [self.physicsWorld addJoint:pinJoint];
        
        
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
   
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
