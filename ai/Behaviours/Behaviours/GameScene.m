//
//  MyScene.m
//  Behaviours
//
//  Created by Jon Manning on 18/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "GameScene.h"
#import "Critter.h"

@implementation GameScene {
    float lastTime;
    
    NSMutableArray* objects;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        objects = [NSMutableArray array];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch* touch in touches) {
        // Make a new critter
        Critter* critter = [self createObject];
        
        // Position it where the touch landed
        critter.position = [touch locationInNode:self];
    }
    
}

- (Critter*) createObject {
    
    // Make a new critter
    Critter* newCritter = [Critter critter];
    
    // 50% chance of being either one that chases or one that flees
    if (arc4random() % 2 == 0) {
        newCritter.critterMode = CritterModeChase;
    } else {
        newCritter.critterMode = CritterModeFlee;
    }
    
    // Add the new critter to the scene
    [self addChild:newCritter];
    [objects addObject:newCritter];
    
    // Remove this new critter after 5 seconds
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [newCritter removeFromParent];
        [objects removeObject:newCritter];
    });
    
    return newCritter;
}

-(void)update:(CFTimeInterval)currentTime {
    
    // Work out how much time has elapsed
    float deltaTime = currentTime - lastTime;
    
    // Update all objects
    for (Critter* critter in objects) {
        [critter update:deltaTime];
    }
    
    lastTime = currentTime;
    
}

@end
