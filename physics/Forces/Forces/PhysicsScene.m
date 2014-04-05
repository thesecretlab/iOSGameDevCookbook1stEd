//
//  MyScene.m
//  Forces
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
        
        // Add the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 100)];
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sprite.physicsBody.density = 0.01;
        
        sprite.name = @"Box";
        
        [self addChild:sprite];
        
        // Add the walls
        SKNode* walls = [SKNode node];
        walls.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self addChild:walls];
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    SKNode* node = [self childNodeWithName:@"Box"];
    
    [node.physicsBody applyForce:CGVectorMake(0, 100)];
    [node.physicsBody applyTorque:0.01];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
