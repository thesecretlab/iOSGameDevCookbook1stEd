//
//  SpaceshipScene.m
//  SpriteWalkthrough
//
//  Created by Jon Manning on 9/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "SpaceshipScene.h"

@interface SpaceshipScene ()
@property BOOL contentCreated;
@end

@implementation SpaceshipScene
- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode* spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:spaceship];
    
    SKAction* makeRocks = [SKAction sequence:@[
                                               [SKAction performSelector:@selector(addRock) onTarget:self],
                                               [SKAction waitForDuration:0.1 withRange:0.15]]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-100, -100, 200, 200) cornerRadius:20 ];
    
    UIBezierPath* rectangle = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 200)];
    UIBezierPath* roundedRectagle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100, 200) cornerRadius:20];
    UIBezierPath* oval = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 200)];

    UIBezierPath* customShape = [UIBezierPath bezierPath];
    [customShape moveToPoint:CGPointMake(0, 0)];
    [customShape addLineToPoint:CGPointMake(0, 100)];
    [customShape addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(100, 100) controlPoint2:CGPointMake(100, 0)];
    [customShape closePath];
    
    SKShapeNode* shape = [[SKShapeNode alloc] init];
    shape.path = [customShape CGPath];
    shape.strokeColor = [UIColor greenColor];
    shape.fillColor = [UIColor redColor];
    
    //shape.glowWidth = 4;
    
    shape.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    
    
    [self addChild:shape];
    
    {
        SKSpriteNode* newShip = [[SKSpriteNode alloc] initWithImageNamed:@"Spaceship"];
        newShip.position = CGPointMake(100, 300);
        newShip.blendMode = SKBlendModeAdd;
        newShip.zPosition = 999;
        [self addChild:newShip];
    }
    {
        SKSpriteNode* newShip = [[SKSpriteNode alloc] initWithImageNamed:@"Spaceship"];
        newShip.position = CGPointMake(250, 300);
        newShip.blendMode = SKBlendModeMultiply;
        newShip.zPosition = 999;
        [self addChild:newShip];
    }
    {
        SKSpriteNode* newShip = [[SKSpriteNode alloc] initWithImageNamed:@"Spaceship"];
        newShip.position = CGPointMake(400, 300);
        newShip.blendMode = SKBlendModeMultiply;
        [self addChild:newShip];
    }
    {
        SKEffectNode* effect = [[SKEffectNode alloc] init];
        effect.position = CGPointMake(550, 300);
        CIFilter* filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:@(20.0) forKey:@"inputRadius"];
        effect.filter = filter;
        SKSpriteNode* newShip = [[SKSpriteNode alloc] initWithImageNamed:@"Spaceship"];
        [effect addChild:newShip];
        [self addChild:effect];
    }
    
    
    
    
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void) addRock {
    SKSpriteNode* rock = [[SKSpriteNode alloc] initWithImageNamed:@"Rock"];
    
    rock.position = CGPointMake(skRand(0, self.size.width), skRand(0, self.size.height));
    rock.name = @"Rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
    
}

- (void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"Rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0) {
            [node removeFromParent];
        }
    }];
}

- (SKSpriteNode*) newSpaceship {
    SKSpriteNode* hull = [[SKSpriteNode alloc] initWithImageNamed:@"Spaceship"];
   //SKSpriteNode* hull = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(64, 32)];
    
    SKAction* hover = [SKAction sequence:@[
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:100 y:50 duration:1.0],
                                           [SKAction waitForDuration:1.0],
                                           [SKAction moveByX:-100 y:-50 duration:1.0]
                                           ]];
    
    [hull runAction:[SKAction repeatActionForever:hover]];
    
    SKSpriteNode* light1 = [self newLight];
    light1.position = CGPointMake(-28.0, 6.0);
    [hull addChild:light1];
    
    SKSpriteNode* light2 = [self newLight];
    light2.position = CGPointMake(28.0, 6.0);
    [hull addChild:light2];
    
    hull.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hull.size];
    
    hull.physicsBody.dynamic = NO;
    
    return hull;
}

- (SKSpriteNode*)newLight {
    SKSpriteNode* light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8, 8)];
    SKAction* blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction* blinkForever = [SKAction repeatActionForever:blink];
    [light runAction:blinkForever];
    
    return light;
}

@end