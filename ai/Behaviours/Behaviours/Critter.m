//
//  Critter.m
//  Behaviours
//
//  Created by Jon Manning on 18/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "Critter.h"
@import GLKit;

@implementation Critter


+ (Critter*) critter {
    // Create a new critter, and give it a name
    Critter* critter = [Critter spriteNodeWithColor:[SKColor yellowColor] size:CGSizeMake(30, 30)];
    critter.name = @"Critter";
    
    critter.movementSpeed = 100; // move at 100 units/s
    critter.turningSpeed = GLKMathDegreesToRadians(45); // turn at 45°/s
    return critter;
}

- (void)setCritterMode:(CritterMode)critterMode {
    
    // Update the colour of this critter depending on the mode that it's in
    _critterMode = critterMode;
    
    switch (critterMode) {
        case CritterModeChase:
            self.color = [SKColor redColor];
            break;
        case CritterModeFlee:
            self.color = [SKColor greenColor];
            break;
        default:
            break;
    }
}

- (void) moveToPosition:(CGPoint)position deltaTime:(float)deltaTime {
    
    // Work out the direction to this position
    GLKVector2 myPosition = GLKVector2Make(self.position.x, self.position.y);
    GLKVector2 targetPosition = GLKVector2Make(position.x, position.y);
    
    GLKVector2 offset = GLKVector2Subtract(targetPosition, myPosition);
    
    // Reduce this vector to be the same length as our movement speed
    offset = GLKVector2Normalize(offset);
    offset = GLKVector2MultiplyScalar(offset, self.movementSpeed * deltaTime);
    
    // Add this to our current position
    CGPoint newPosition = self.position;
    newPosition.x += offset.x;
    newPosition.y += offset.y;
    
    self.position = newPosition;
}

- (void) moveToTarget:(Critter*)target deltaTime:(float)deltaTime {
    
    [self moveToPosition:target.position deltaTime:deltaTime];
}

- (void) interceptTarget:(Critter*)target deltaTime:(float)deltaTime {
    
    GLKVector2 myPosition = GLKVector2Make(self.position.x, self.position.y);
    GLKVector2 targetPosition = GLKVector2Make(target.position.x, target.position.y);
    
    GLKVector2 toTarget = GLKVector2Subtract(targetPosition, myPosition);
    
    float lookAheadTime = GLKVector2Length(toTarget) / (self.movementSpeed + target.movementSpeed);
    
    CGPoint destination = target.position;
    destination.x += target.movementSpeed * lookAheadTime;
    destination.y += target.movementSpeed * lookAheadTime;
    
    [self moveToPosition:destination deltaTime:deltaTime];
    
}

- (void) fleeFromTarget:(Critter*)target deltaTime:(float)deltaTime {
    GLKVector2 myPosition = GLKVector2Make(self.position.x, self.position.y);
    GLKVector2 targetPosition = GLKVector2Make(target.position.x, target.position.y);
    
    GLKVector2 offset = GLKVector2Subtract(targetPosition, myPosition);
    
    // Reduce this vector to be the same length as our movement speed
    offset = GLKVector2Normalize(offset);
    
    // Note the minus sign - we're multiplying by the inverse of our movement speed,
    // which means we're moving away from it
    offset = GLKVector2MultiplyScalar(offset, -self.movementSpeed * deltaTime);
    
    // Add this to our current position
    CGPoint newPosition = self.position;
    newPosition.x += offset.x;
    newPosition.y += offset.y;
    
    self.position = newPosition;
}

- (CGVector) forwardVector {
    CGVector velocity = CGVectorMake(0, 1);
    
    CGVector rotatedVelocity;
    rotatedVelocity.dx = velocity.dx * cos(self.zRotation) - velocity.dy * sin(self.zRotation);
    rotatedVelocity.dy = velocity.dy * cos(self.zRotation) + velocity.dx * sin(self.zRotation);
    
    return rotatedVelocity;

}

- (void) moveForwardWithDeltaTime:(float)deltaTime {
    
    CGVector forward = [self forwardVector];
    
    CGPoint newPosition = self.position;
    
    newPosition.x += forward.dx * self.movementSpeed * deltaTime;
    newPosition.y += forward.dy * self.movementSpeed * deltaTime;
    
    self.position = newPosition;
}

- (void) findNearbyTarget {
    SKScene* scene = self.scene;
    
    
    __block float nearestNodeDistance = INFINITY;
    __block id nearestNode = nil;
    
    GLKVector2 myPosition = GLKVector2Make(self.position.x, self.position.y);
    
    // Find the nearest critter
    [scene enumerateChildNodesWithName:@"Critter" usingBlock:^(SKNode *node, BOOL *stop) {
        
        Critter* otherCritter = (Critter*) node;
        if (otherCritter.critterMode == self.critterMode)
            return;
        
        if (node == self)
            return;
        
        GLKVector2 targetPosition = GLKVector2Make(node.position.x, node.position.y);
        GLKVector2 toTarget = GLKVector2Subtract(targetPosition, myPosition);
        
        float length = GLKVector2Length(toTarget);
        
        if (length < nearestNodeDistance) {
            nearestNode = node;
            nearestNodeDistance = length;
        }
        
    }];
    
    self.target = nearestNode;
    
}

- (void) turnTowardsTarget:(CGPoint)target deltaTime:(float)deltaTime {
    
    // Work out the vector from our position to the target
    GLKVector2 myPosition = GLKVector2Make(self.position.x, self.position.y);
    GLKVector2 targetPosition = GLKVector2Make(target.x, target.y);
    GLKVector2 toTarget = GLKVector2Subtract(targetPosition, myPosition);
    
    CGVector forward = [self forwardVector];
    GLKVector2 forwardVector = GLKVector2Make(forward.dx, forward.dy);
    
    // Get the angle needed to turn towards this position
    float angle = GLKVector2DotProduct(toTarget, forwardVector);
    angle /= acos(GLKVector2Length(toTarget) * GLKVector2Length(forwardVector));
    
    // Clamp the angle to our turning speed
    angle = fminf(angle, self.turningSpeed);
    angle = fmaxf(angle, -self.turningSpeed);
    
    // Apply the rotation
    self.zRotation += angle * deltaTime;
    
}

- (void) update:(float)deltaTime {
    
    // If we don't have a target, find the nearest one
    if (self.target == nil) {
        [self findNearbyTarget];
    }
    
    // If we still don't have a target, give up
    if (self.target == nil)
        return;
    
    // Turn towards our new target
    [self turnTowardsTarget:self.target.position deltaTime:deltaTime];
    
    // Depending on the mode, either try to intercept them or flee from them
    switch (self.critterMode) {
        case CritterModeChase:
            [self interceptTarget:self.target deltaTime:deltaTime];
            break;
        case CritterModeFlee:
            [self fleeFromTarget:self.target deltaTime:deltaTime];
            break;
        default:
            break;
    }
}

@end
