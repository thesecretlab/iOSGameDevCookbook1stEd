//
//  MyScene.m
//  Thrusters
//
//  Created by Jon Manning on 19/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

@interface PhysicsScene ()

@property (assign) float lastTime;

@end

@implementation PhysicsScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        // Add the sprite
        SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 100)];
        sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        sprite.name = @"Box";
        
        [self addChild:sprite];
        
        // Add the walls
        SKNode* walls = [SKNode node];
        walls.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self addChild:walls];
        
    }
    return self;
}

- (void)update:(NSTimeInterval)currentTime {
    
    /* Called before each frame is rendered */
    
    if (self.lastTime == 0)
        self.lastTime = currentTime;
    
    float deltaTime = currentTime - self.lastTime;
    
    SKNode* node = [self childNodeWithName:@"Box"];
    
    [node.physicsBody applyForce:CGVectorMake(0 * deltaTime, 10 * deltaTime)];
    [node.physicsBody applyTorque:0.5 * deltaTime];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}


@end
