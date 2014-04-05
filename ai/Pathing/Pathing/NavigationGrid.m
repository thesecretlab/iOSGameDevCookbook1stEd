//
//  AStar.m
//  Pathing
//
//  Created by Jon Manning on 20/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "NavigationGrid.h"

@interface NavigationNode : NSObject

// The location of the node
@property (assign) CGPoint position;

// The list of nearby nodes
@property (strong) NSArray* neighbours;

// The "cost" that would be incurred if the path went through this node
@property (assign) float fScore;

// The "cost" from this point along the best known path
@property (assign) float gScore;

// The distance from this node to another node
- (float) distanceToNode:(NavigationNode*)node;

// The distance from the node's position to a point
- (float) distanceToPoint:(CGPoint)point;

@end

@implementation NavigationNode

// Returns the distance from the node's position to a given point
- (float)distanceToPoint:(CGPoint)point {
    CGPoint offset;
    offset.x = point.x - self.position.x;
    offset.y = point.y - self.position.y;
    
    float length = sqrt(offset.x * offset.x + offset.y * offset.y);
    
    return length;
}

// Returns the distance from the node's position to another node
- (float)distanceToNode:(NavigationNode *)node {
    return [self distanceToPoint:node.position];
}

@end

@implementation NavigationGrid {
    NSMutableArray* nodes;
}

- (void)createNodesWithPoints:(NSArray *)points maximumNeighbourDistance:(float)distance {
    
    nodes = [NSMutableArray array];
    
    // Create the nodes
    for (NSValue* pointValue in points) {
        NavigationNode* node = [[NavigationNode alloc] init];
        
        node.position = pointValue.CGPointValue;
        
        [nodes addObject:node];
    }
    
    // Work out which nodes are neighbours
    for (NavigationNode* node in nodes) {
        
        NSMutableArray* neighbours = [NSMutableArray array];
        
        for (NavigationNode* otherNode in nodes) {
            if (otherNode == node)
                continue;
            
            // If the distance to this node is shorter than or the same
            // as the maximum allowed distance, add this as a neighbour
            if ([node distanceToNode:otherNode] <= distance) {
                [neighbours addObject:otherNode];
            }
        }
        
        node.neighbours = neighbours;
    }
    
}

// Find the nearest node to the given point
- (NavigationNode*) nearestNodeToPoint:(CGPoint)point {
    
    NavigationNode* nearestNode = nil;
    float closestDistance = INFINITY;
    
    for (NavigationNode* node in nodes) {
        
        float distance = [node distanceToPoint:point];
        
        if (distance < closestDistance) {
            closestDistance = distance;
            nearestNode = node;
        }
        
    }
    return nearestNode;
}

// Calculate the path from the origin to the destination
- (NSArray*) pathFromPoint:(CGPoint)origin toPoint:(CGPoint)destination {
    
    // First, find the nearest nodes to the origin and end point
    NavigationNode* startNode = [self nearestNodeToPoint:origin];
    NavigationNode* goalNode = [self nearestNodeToPoint:destination];
    
    // Reset the f-scores and g-scores for each node
    for (NavigationNode* node in nodes) {
        node.fScore = 0;
        node.gScore = 0;
    }
    
    // The set of nodes that have been evaluated
    NSMutableSet* closedSet = [NSMutableSet set];
    
    // The set of nodes that should be evaluated, starting with the startNode
    NSMutableSet* openSet = [NSMutableSet setWithObject:startNode];
    
    // A weak mapping from nodes, used to re-construct the path
    NSMapTable* cameFromMap = [NSMapTable weakToWeakObjectsMapTable];
    
    // Loop while there are still nodes to consider
    while (openSet.count > 0) {
        
        // Find the node in the open set with the lowest f-score
        NavigationNode* currentNode = [[openSet sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"fScore" ascending:YES]]] firstObject];
        
        // If we've managed to get to the goal, reconstruct a path
        if (currentNode == goalNode) {
            NSArray* pathNodes = [self reconstructPath:cameFromMap currentNode:currentNode];
            
            // Make an array containing just points (instead of NavigationNodes)
            NSMutableArray* pathPoints = [NSMutableArray array];
            for (NavigationNode* node in pathNodes) {
                [pathPoints addObject:[NSValue valueWithCGPoint:node.position]];
            }
            
            return pathPoints;
        }
        
        // Move the current node from the open set to the closed set
        [openSet removeObject:currentNode];
        [closedSet addObject:currentNode];
        
        // Check each neighbour for the next best point to check
        for (NavigationNode* neighbour in currentNode.neighbours) {
            float tentativeGScore = currentNode.gScore + [currentNode distanceToNode:neighbour];
            float tentativeFScore = tentativeGScore + [currentNode distanceToNode:goalNode];
            
            // If this neighbour has already been checked, and using it as part of the path would be worse,
            // skip it
            if ([closedSet containsObject:neighbour] && tentativeFScore >= neighbour.fScore) {
                continue;
            }
            
            // If we haven't checked this node yet, or using it would be better, add it to the current path
            if ([openSet containsObject:neighbour] == NO || tentativeFScore < neighbour.fScore) {
                [cameFromMap setObject:currentNode forKey:neighbour];
                
                // Update the estimated costs for using this node
                neighbour.fScore = tentativeFScore;
                neighbour.gScore = tentativeGScore;
                
                // Add it to the open set, so we explore using it more
                [openSet addObject:neighbour];
                
            }
        }
    }
    
    return nil;
    
}

// Given a point, recursively work out the chain of
- (NSArray*) reconstructPath:(NSMapTable*)cameFromMap currentNode:(NavigationNode*)currentNode {
    if ([cameFromMap objectForKey:currentNode]) {
        NSArray* path = [self reconstructPath:cameFromMap currentNode:[cameFromMap objectForKey:currentNode]];
        return [path arrayByAddingObject:currentNode];
    } else {
        return @[currentNode];
    }
}

@end
