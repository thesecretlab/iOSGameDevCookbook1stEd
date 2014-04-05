//
//  Camera.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Component.h"
#import <GLKit/GLKit.h>

@interface Camera : Component

// A matrix that maps world-space to view-space
- (GLKMatrix4) viewMatrix;

// A matrix that maps view-space to eye-space
- (GLKMatrix4) projectionMatrix;

// Field of view, in radians
@property (assign) float fieldOfView;

// Near clipping plane, in units
@property (assign) float nearClippingPlane;

// Far clipping plane, in units
@property (assign) float farClippingPlane;

// Clears screen contents and gets ready to draw
- (void) prepareToDraw;

// The colour to erase the screen with
@property (assign) GLKVector4 clearColor;

@end
