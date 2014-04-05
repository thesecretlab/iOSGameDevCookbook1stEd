//
//  MyScene.m
//  Pathing
//
//  Created by Jon Manning on 20/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "GameScene.h"
#import "Robot.h"

@implementation GameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        Robot* robot = [Robot robot];
        
        [robot moveToPath:@[ [NSValue valueWithCGPoint:(CGPoint){100,100}],
                             [NSValue valueWithCGPoint:(CGPoint){0,50}],
                             [NSValue valueWithCGPoint:(CGPoint){0,0}]
                             ]];
        
        [self addChild:robot];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
