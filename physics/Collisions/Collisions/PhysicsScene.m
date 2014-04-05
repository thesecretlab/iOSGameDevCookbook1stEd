//
//  MyScene.m
//  Collisions
//
//  Created by Jon Manning on 18/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

const int myObjectBitMask = 0x00001;

@interface PhysicsScene () <SKPhysicsContactDelegate>

@end

@implementation PhysicsScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor blackColor];
        
        [self createPhysicsSprite];
        [self createStaticPhysicsSprite];
        
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact started between %@ and %@", contact.bodyA, contact.bodyB);
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    NSLog(@"Contact ended between %@ and %@", contact.bodyA, contact.bodyB);
}


- (void) createPhysicsSprite {
    SKSpriteNode* physicsSprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 100)];
    
    
    physicsSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100);
    physicsSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:physicsSprite.size];
    
    physicsSprite.physicsBody.contactTestBitMask = myObjectBitMask;

    [self addChild:physicsSprite];
}

- (void)createStaticPhysicsSprite {
    SKSpriteNode* staticSprite = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(200, 25)];
    
    staticSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
    staticSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:staticSprite.size];
    staticSprite.physicsBody.dynamic = NO;
    
    staticSprite.physicsBody.contactTestBitMask = myObjectBitMask;
    
    [self addChild:staticSprite];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
