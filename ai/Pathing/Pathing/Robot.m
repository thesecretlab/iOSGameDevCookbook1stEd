//
//  Robot.m
//  Pathing
//
//  Created by Jon Manning on 20/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "Robot.h"
@import GLKit;

@implementation Robot

+ (Robot*) robot {
    Robot* robot = [[Robot alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(70, 70)];
    
    return robot;
}

- (void) moveToPath:(NSArray*)pathPoints {
    
    CGPoint myPosition = CGPointZero;
    CGPoint coverPosition = CGPointZero;
    
    __block BOOL canUseCover = NO;

    
    [self.scene.physicsWorld enumerateBodiesAlongRayStart:myPosition end:coverPosition usingBlock:^(SKPhysicsBody *body, CGPoint point, CGVector normal, BOOL *stop) {
        
        if (body == self.physicsBody)
            return;
        
        // We hit something, so there's something between us and the cover point. Good!
        canUseCover = YES;
        
        // Stop looping
        *stop = YES;
    }];
    
    if (canUseCover) {
        // take cover
    }
    
    if (pathPoints.count == 0)
        return;
    
    CGPoint nextPoint = [[pathPoints firstObject] CGPointValue];
    
    GLKVector2 currentPosition = GLKVector2Make(self.position.x, self.position.y);
    GLKVector2 nextPointVector = GLKVector2Make(nextPoint.x, nextPoint.y);
    
    GLKVector2 toTarget = GLKVector2Subtract(nextPointVector, currentPosition);
    
    float distance = GLKVector2Length(toTarget);
    
    float speed = 50;
    float time = distance / speed;
    
    SKAction* moveAction = [SKAction moveTo:nextPoint duration:time];
    SKAction* nextPointAction = [SKAction runBlock:^{
        NSMutableArray* nextPoints = [NSMutableArray arrayWithArray:pathPoints];
        [nextPoints removeObjectAtIndex:0];
        [self moveToPath:nextPoints];
    }];
    
    [self runAction:[SKAction sequence:@[moveAction, nextPointAction]]];
}


@end
