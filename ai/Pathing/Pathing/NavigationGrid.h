//
//  AStar.h
//  Pathing
//
//  Created by Jon Manning on 20/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationGrid : NSObject

- (void) createNodesWithPoints:(NSArray*)points maximumNeighbourDistance:(float)distance;

// Returns an NSArray containing NSValues, each of which is contains a CGPoint
- (NSArray*) pathFromPoint:(CGPoint)origin toPoint:(CGPoint)destination;

@end
