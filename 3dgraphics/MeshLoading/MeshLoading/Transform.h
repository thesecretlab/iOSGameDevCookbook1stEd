//
//  Transform.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Component.h"
#import <GLKit/GLKit.h>

@interface Transform : Component

@property (weak) Transform* parent;
@property (strong, readonly) NSSet* children;

- (void) addChild:(Transform*)child;
- (void) removeChild:(Transform*)child;

// Location in world space
@property (readonly, assign) GLKVector3 position;

// The orientation of the transform in world space
@property (readonly, assign) GLKQuaternion rotation;

// Scale in world space
@property (readonly, assign) GLKVector3 scale;

// Vectors relative to us
@property (readonly) GLKVector3 up;
@property (readonly) GLKVector3 forward;
@property (readonly) GLKVector3 left;

// The matrix that maps local coordinates to world coordinates.
@property (readonly) GLKMatrix4 localToWorldMatrix;

// -----

// Position relative to parent
@property (assign) GLKVector3 localPosition;

// Rotation angles relative to parent, in radians
@property (assign) GLKVector3 localRotation;

// Scale relative to parent
@property (assign) GLKVector3 localScale;

- (void) translate:(GLKVector3)offset;
- (void) rotate:(GLKVector3)angles;
- (void) scale:(GLKVector3)scaleAmounts;

@end
