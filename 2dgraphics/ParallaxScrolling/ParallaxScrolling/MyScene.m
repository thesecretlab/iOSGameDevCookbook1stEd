//
//  MyScene.m
//  ParallaxScrolling
//
//  Created by Jon Manning on 11/03/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    
    // Sky
    SKSpriteNode* skyNode;
    SKSpriteNode* skyNodeNext;
    
    // Foreground hills
    SKSpriteNode* hillsNode;
    SKSpriteNode* hillsNodeNext;
    
    // Background hills
    SKSpriteNode* distantHillsNode;
    SKSpriteNode* distantHillsNodeNext;
    
    // Path
    SKSpriteNode* pathNode;
    SKSpriteNode* pathNodeNext;
    
    // Time of last frame
    CFTimeInterval lastFrameTime;
    
    // Time since last frame
    CFTimeInterval deltaTime;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        // Prepare the sky sprites
        skyNode = [SKSpriteNode spriteNodeWithTexture:
                [SKTexture textureWithImageNamed:@"Sky"]];
        skyNode.position = CGPointMake(CGRectGetMidX(self.frame), 
                                       CGRectGetMidY(self.frame));
        
        skyNodeNext = [skyNode copy];
        skyNodeNext.position = 
            CGPointMake(skyNode.position.x + skyNode.size.width, skyNode.position.y);
        
        // Prepare the background hill sprites
        distantHillsNode = [SKSpriteNode spriteNodeWithTexture:
            [SKTexture textureWithImageNamed:@"DistantHills"]];
        distantHillsNode.position = 
            CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 284);
        
        distantHillsNodeNext = [distantHillsNode copy];
        distantHillsNodeNext.position = 
            CGPointMake(distantHillsNode.position.x + distantHillsNode.size.width, 
                        distantHillsNode.position.y);
        
        // Prepare the foreground hill sprites
        hillsNode = [SKSpriteNode spriteNodeWithTexture:
            [SKTexture textureWithImageNamed:@"Hills"]];
        hillsNode.position = 
            CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 384);
        
        hillsNodeNext = [hillsNode copy];
        hillsNodeNext.position = 
            CGPointMake(hillsNode.position.x + hillsNode.size.width, hillsNode.position.y);
        
        // Prepare the path sprites
        pathNode = [SKSpriteNode spriteNodeWithTexture:
            [SKTexture textureWithImageNamed:@"Path"]];
        pathNode.position = 
            CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 424);
        
        pathNodeNext = [pathNode copy];
        pathNodeNext.position = 
            CGPointMake(pathNode.position.x + pathNode.size.width, 
                        pathNode.position.y);
        
        // Add the sprites to the scene
        [self addChild:skyNode];
        [self addChild:skyNodeNext];
        
        [self addChild:distantHillsNode];
        [self addChild:distantHillsNodeNext];
        
        [self addChild:hillsNode];
        [self addChild:hillsNodeNext];
        
        [self addChild:pathNode];
        [self addChild:pathNodeNext];
        
    }
    return self;
}

// Move a pair of sprites leftward based on a speed value; when either of 
// the sprites goes off-screen, move it to the right so that it appears to be
// seamless movement
- (void) moveSprite:(SKSpriteNode*)sprite 
         nextSprite:(SKSpriteNode*)nextSprite 
              speed:(float)speed {
    
    CGPoint newPosition;
    
    // For both the sprite and its duplicate:
    for (SKSpriteNode* spriteToMove in @[sprite, nextSprite]) {
        
        // Shift the sprite leftward based on the speed
        newPosition = spriteToMove.position;
        newPosition.x -= speed * deltaTime;
        spriteToMove.position = newPosition;
        
        // If this sprite is now off-screen (i.e. its rightmost edge is further
        // left than the scene's leftmost edge):
        if (CGRectGetMaxX(spriteToMove.frame) < CGRectGetMinX(self.frame)) {
            
            // Shift it over so that it's now to the immediate right of the
            // other sprite.
            // This means that the two sprites are effectively leap-frogging
            // each other as they both move.
            spriteToMove.position = 
                CGPointMake(spriteToMove.position.x + spriteToMove.size.width * 2, 
                            spriteToMove.position.y);
        }
    }
}

- (void)update:(CFTimeInterval)currentTime {
    
    // First, update the delta time values:
    
    // If we don't have a last frame time value, this is the first frame, so
    // delta time will be zero.
    if (lastFrameTime <= 0)
        lastFrameTime = currentTime;
    
    // Update delta time
    deltaTime = currentTime - lastFrameTime;
    
    // Set last frame time to current time
    lastFrameTime = currentTime;
    
    // Next, move each of the four pairs of sprites.
    // Objects that should appear move slower than foreground objects.
    [self moveSprite:skyNode nextSprite:skyNodeNext speed:25.0];
    [self moveSprite:distantHillsNode nextSprite:distantHillsNodeNext speed:50.0];
    [self moveSprite:hillsNode nextSprite:hillsNodeNext speed:100.0];
    [self moveSprite:pathNode nextSprite:pathNodeNext speed:150.0];
}

@end
