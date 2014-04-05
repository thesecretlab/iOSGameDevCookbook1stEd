//
//  MyScene.m
//  Explosion
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
        
        // Add 50 small boxes
        
        for (int i = 0; i < 50; i++) {
            SKSpriteNode* node = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(20, 20)];
            node.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
            node.physicsBody.density = 0.01;
            
            [self addChild:node];
        }
        
        // Add the walls
        SKNode* walls = [SKNode node];
        walls.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self addChild:walls];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // Apply an explosion force at each touch point
    
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInNode:self];
        
        [self applyExplosionAtPoint:point radius:150 power:10];
    }
    
}

- (void) applyExplosionAtPoint:(CGPoint)point radius:(float)radius power:(float)power{
    
    // Work out which bodies are in range of the explosion by creating a rectangle
    CGRect explosionRect = CGRectMake(point.x - radius, point.y - radius,
                                      radius*2, radius*2);
    
    // For each body, apply an explosion force
    [self.physicsWorld enumerateBodiesInRect:explosionRect usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
        
        // Work out the direction that we should apply the force in for this body
        CGVector explosionOffset = CGVectorMake(body.node.position.x - point.x, body.node.position.y - point.y);
        
        // Work out the distance from the explosion point
        CGFloat explosionDistance = sqrtf(explosionOffset.dx * explosionOffset.dx + explosionOffset.dy * explosionOffset.dy);
        
        // Normalise the explosion force
        CGVector explosionForce = explosionOffset;
        explosionForce.dx /= explosionDistance;
        explosionForce.dy /= explosionDistance;
        
        // Multiply by power
        explosionForce.dx *= power;
        explosionForce.dy *= power;
        
        // Finally, apply the force
        [body applyForce:explosionForce];
        
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
