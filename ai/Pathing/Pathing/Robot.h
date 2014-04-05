//
//  Robot.h
//  Pathing
//
//  Created by Jon Manning on 20/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Robot : SKSpriteNode

+ (Robot*) robot;

- (void) moveToPath:(NSArray*)pathPoints;

@end
