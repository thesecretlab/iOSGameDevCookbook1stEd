//
//  MyScene.m
//  Dragging
//
//  Created by Jon Manning on 12/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

@implementation PhysicsScene {
    SKNode* dragNode;
    SKPhysicsJointPin* dragJoint;
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        [self createWalls];
        
        for (int i = 0; i < 5; i++) {
            SKSpriteNode* box = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50, 50)];
            box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
            box.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self addChild:box];
        }
        
        
        // Only allow a single touch at a time
        self.view.multipleTouchEnabled = NO;
    }
    return self;
}

- (void) createWalls {
    
    SKNode* wallsNode = [SKNode node];
    wallsNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGRect rect = CGRectOffset(self.frame, -self.frame.size.width / 2.0, -self.frame.size.height / 2.0);
    wallsNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:rect];
    
    [self addChild:wallsNode];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // We only care about one touch at a time
    UITouch* touch = [touches anyObject];
    
    // Work out what node got touched
    CGPoint touchPosition = [touch locationInNode:self];
    SKNode* touchedNode = [self nodeAtPoint:touchPosition];
    
    // Make sure that we're touching something that _can_ be dragged
    if (touchedNode == nil || touchedNode == dragNode)
        return;
    
    // Make sure that the object we touched has a physics body
    if (touchedNode.physicsBody == nil)
        return;
    
    // Create the invisible drag node, with a small static body
    dragNode = [SKNode node];
    dragNode.position = touchPosition;
    dragNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
    dragNode.physicsBody.dynamic = NO;
    
    [self addChild:dragNode];
    
    // Link this new node to the object that got touched
    dragJoint = [SKPhysicsJointPin jointWithBodyA:touchedNode.physicsBody
                                            bodyB:dragNode.physicsBody
                                           anchor:touchPosition];
    
    [self.physicsWorld addJoint:dragJoint];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    
    // When the touch moves, move the static drag node. The joint will drag the connected
    // object with it.
    CGPoint touchPosition = [touch locationInNode:self];
    
    dragNode.position = touchPosition;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self stopDragging];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self stopDragging];
}

- (void) stopDragging {
    // Remove the joint and the drag node.
    [self.physicsWorld removeJoint:dragJoint];
    dragJoint = nil;
    
    [dragNode removeFromParent];
    dragNode = nil;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
