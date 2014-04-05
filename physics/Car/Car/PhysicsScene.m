//
//  MyScene.m
//  Car
//
//  Created by Jon Manning on 12/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

@implementation PhysicsScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self createCar];
        
        [self createWalls];
        
        //self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        
    }
    return self;
}


- (SKNode*) createWheelWithRadius:(float)wheelRadius {
    CGRect wheelRect = CGRectMake(-wheelRadius, -wheelRadius, wheelRadius*2, wheelRadius*2);
    
    SKShapeNode* wheelNode = [[SKShapeNode alloc] init];
    wheelNode.path = [UIBezierPath bezierPathWithOvalInRect:wheelRect].CGPath;
    
    return wheelNode;
}

- (void) createWalls {
    
    SKNode* wallsNode = [SKNode node];
    wallsNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGRect rect = CGRectOffset(self.frame, -self.frame.size.width / 2.0, -self.frame.size.height / 2.0);
    wallsNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
    
    [self addChild:wallsNode];
}

- (void) createCar {
    
    // Create the car
    SKSpriteNode* carNode = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(150, 50)];
    carNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:carNode.size];
    carNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:carNode];
    
    // Create the left wheel
    SKNode* leftWheelNode = [self createWheelWithRadius:30];
    leftWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
    leftWheelNode.position = CGPointMake(carNode.position.x-80, carNode.position.y);
    [self addChild:leftWheelNode];
    
    // Create the right wheel
    SKNode* rightWheelNode = [self createWheelWithRadius:30];
    rightWheelNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:30];
    rightWheelNode.position = CGPointMake(carNode.position.x+80, carNode.position.y);
    [self addChild:rightWheelNode];
    
    // Attach the wheels to the body
    CGPoint leftWheelPosition = leftWheelNode.position;
    CGPoint rightWheelPosition = rightWheelNode.position;
    
    SKPhysicsJointPin* leftPinJoint = [SKPhysicsJointPin jointWithBodyA:carNode.physicsBody bodyB:leftWheelNode.physicsBody anchor:leftWheelPosition];
    SKPhysicsJointPin* rightPinJoint = [SKPhysicsJointPin jointWithBodyA:carNode.physicsBody bodyB:rightWheelNode.physicsBody anchor:rightWheelPosition];
    
    [self.physicsWorld addJoint:leftPinJoint];
    [self.physicsWorld addJoint:rightPinJoint];
}


@end
