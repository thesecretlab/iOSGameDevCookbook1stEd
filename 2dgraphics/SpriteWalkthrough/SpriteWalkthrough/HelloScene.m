//
//  HelloScene.m
//  SpriteWalkthrough
//
//  Created by Jon Manning on 9/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "HelloScene.h"
#import "SpaceshipScene.h"

@implementation HelloScene {
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view {
    if (_contentCreated == NO) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void) createSceneContents {
    self.backgroundColor = [SKColor blueColor];
    
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    [self addChild:[self newHelloNode]];
}

- (SKLabelNode*) newHelloNode {
    
    SKLabelNode* helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    helloNode.text = @"Hello, world!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    helloNode.name = @"helloNode";
    
    return helloNode;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKNode* helloNode = [self childNodeWithName:@"helloNode"];
    
    if (helloNode != nil) {
        helloNode.name = nil;
        SKAction* moveUp = [SKAction moveByX:0 y:100.0 duration:0.5];
        SKAction* zoom = [SKAction scaleTo:2.0 duration:0.25];
        SKAction* pause = [SKAction waitForDuration:0.5];
        SKAction* fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction* remove = [SKAction removeFromParent];
        SKAction* moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        
        [helloNode runAction:moveSequence completion:^{
            SpaceshipScene* spaceship = [[SpaceshipScene alloc] initWithSize:self.size];
            SKTransition* doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            
            [self.view presentScene:spaceship transition:doors];
        }];
        
    }
}

@end
