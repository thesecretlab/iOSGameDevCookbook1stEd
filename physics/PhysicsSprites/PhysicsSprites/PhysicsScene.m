//
//  MyScene.m
//  PhysicsSprites
//
//  Created by Jon Manning on 16/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PhysicsScene.h"

@implementation PhysicsScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        [self createPhysicsSprite];
        [self createStaticPhysicsSprite];
        [self createCircularSprite];
        [self createPolygonSprite];
        
        [self createWalls];
        
        [self createEdgeSprite];
        
        [self createCustomMassSprite];
        
        CGRect searchRect = CGRectMake(10, 10, 200, 200);
        
        [self.physicsWorld enumerateBodiesInRect:searchRect usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
            NSLog(@"Found a body: %@", body);
        }];
        
        CGPoint searchPoint = CGPointMake(40, 100);
        
        [self.physicsWorld enumerateBodiesAtPoint:searchPoint usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
            NSLog(@"Found a body: %@", body);
        }];
        
        CGPoint searchRayStart = CGPointMake(0, 0);
        CGPoint searchRayEnd = CGPointMake(320, 480);
        
        [self.physicsWorld enumerateBodiesAlongRayStart:searchRayStart end:searchRayEnd usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
            NSLog(@"Found a body: %@ (normal: %.1f, %.1f)", body, normal.dx, normal.dy);
        }];
        
        {
            SKPhysicsBody* body = [self.physicsWorld bodyAtPoint:searchPoint];
        }
        {
            SKPhysicsBody* body = [self.physicsWorld bodyInRect:searchRect];
        }
        {
            SKPhysicsBody* body = [self.physicsWorld bodyAlongRayStart:searchRayStart end:searchRayEnd];
        }
        
        
        
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

- (void) createEdgeSprite {
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-50, -10)];
    [path addLineToPoint:CGPointMake(-25, 10)];
    [path addLineToPoint:CGPointMake(0, -10)];
    [path addLineToPoint:CGPointMake(25, 10)];
    [path addLineToPoint:CGPointMake(50, -10)];
    
    SKShapeNode* wallNode = [[SKShapeNode alloc] init];
    wallNode.path = path.CGPath;
    wallNode.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path.CGPath];
    wallNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-50);
    
    [self addChild:wallNode];
}

- (void) createPhysicsSprite {
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 50)];
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:sprite];
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    
    sprite.physicsBody.velocity = CGVectorMake(0, 500);
    
}

- (void) createCustomMassSprite {
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(100, 50)];
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 500);
    [self addChild:sprite];
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    
    sprite.physicsBody.density = 2.0;
    
}

- (void)createStaticPhysicsSprite {
    SKSpriteNode* staticSprite = [SKSpriteNode spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(200, 25)];
    
    staticSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
    staticSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:staticSprite.size];
    staticSprite.physicsBody.dynamic = NO;
    
    [self addChild:staticSprite];
}

- (void) createCircularSprite {
    SKShapeNode* circleSprite = [[SKShapeNode alloc] init];
    circleSprite.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-50, -50, 100, 100)].CGPath;
    circleSprite.lineWidth = 1;
    circleSprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50];
    circleSprite.position = CGPointMake(CGRectGetMidX(self.frame)+40, CGRectGetMidY(self.frame) + 100);
    
    [self addChild:circleSprite];
}

- (void) createPolygonSprite {
    SKShapeNode* polygonSprite = [[SKShapeNode alloc] init];
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(-25, -25)];
    [path addLineToPoint:CGPointMake(25, 0)];
    [path addLineToPoint:CGPointMake(-25, 25)];
    [path closePath];

    polygonSprite.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path.CGPath];
    polygonSprite.path = path.CGPath;
    polygonSprite.lineWidth = 1;
    polygonSprite.position = CGPointMake(CGRectGetMidX(self.frame)-20, CGRectGetMidY(self.frame) + 100);
    
    [self addChild:polygonSprite];
}

- (void)didSimulatePhysics {
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
