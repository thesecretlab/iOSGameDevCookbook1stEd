//
//  MyScene.m
//  FrameAnimation
//
//  Created by Jon Manning on 11/02/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
        
        // Load the texture atlas
        SKTextureAtlas* atlas = [SKTextureAtlas atlasNamed:@"Animation"];
        
        // Get the list of texture names, and sort them
        NSArray* textureNames = [[atlas textureNames] sortedArrayUsingSelector:@selector(compare:)];
        
        // Load all textures
        NSMutableArray* allTextures = [NSMutableArray array];
        
        for (NSString* textureName in textureNames) {
            [allTextures addObject:[atlas textureNamed:textureName]];
        }
        
        // Create the sprite, and give it the initial frame; position it in the middle of the screen
        SKSpriteNode* animatedSprite = [SKSpriteNode spriteNodeWithTexture:allTextures[0]];
        animatedSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:animatedSprite];
        
        // Make the sprite animate using the loaded textures, at a rate of 30 frames per second
        SKAction* animationAction = [SKAction animateWithTextures:allTextures timePerFrame:(1.0/30.0)];
        [animatedSprite runAction:[SKAction repeatActionForever:animationAction]];
        
        
        
    }
    return self;
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
