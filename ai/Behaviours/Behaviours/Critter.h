//
//  Critter.h
//  Behaviours
//
//  Created by Jon Manning on 18/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    CritterModeChase,
    CritterModeFlee
} CritterMode;

@interface Critter : SKSpriteNode

@property (assign) float movementSpeed;
@property (assign) float turningSpeed;

@property (weak) Critter* target;

+ (Critter*) critter;

- (void) update:(float)deltaTime;

@property (nonatomic, assign) CritterMode critterMode;

@end
