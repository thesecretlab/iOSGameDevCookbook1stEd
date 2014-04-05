//
//  MyScene.m
//  AccelerometerGravity
//
//  Created by Jon Manning on 12/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"
#import <CoreMotion/CoreMotion.h>

@implementation PhysicsScene {
    CMMotionManager* motionManager;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        motionManager = [[CMMotionManager alloc] init];
        
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            CGVector gravityVector = CGVectorMake(motion.gravity.x, motion.gravity.y);
            
            gravityVector.dx *= 9.81;
            gravityVector.dy *= 9.81;
            
            self.physicsWorld.gravity = gravityVector;
            
        }];
        
        [self createWalls];
        
        SKSpriteNode* ball = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(20, 20)];
        ball.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ball.size];
        ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:ball];
        
        
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
    
    
    

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
