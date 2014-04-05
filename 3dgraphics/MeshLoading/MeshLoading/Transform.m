//
//  Transform.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Transform.h"

@interface Transform () {
    NSMutableSet* _children;
}

@end

@implementation Transform

@dynamic position;
@dynamic rotation;
@dynamic scale;

@dynamic up;
@dynamic left;
@dynamic forward;

- (id)init
{
    self = [super init];
    if (self) {
        // The list of children
        _children = [NSMutableSet set];
        
        // By default, we're scaled to 1 on all 3 axes
        _localScale = GLKVector3Make(1, 1, 1);
    }
    return self;
}

// Add a transform as a child of us
- (void)addChild:(Transform *)child {
    [_children addObject:child];
    child.parent = self;
}

// Remove a transform from the list of children
- (void)removeChild:(Transform *)child {
    [_children removeObject:child];
    child.parent = nil;
}

- (GLKVector3)rotateVector:(GLKVector3)vector {
    GLKMatrix4 matrix = GLKMatrix4Identity;
    matrix = GLKMatrix4RotateX(matrix, self.localRotation.x);
    matrix = GLKMatrix4RotateY(matrix, self.localRotation.y);
    matrix = GLKMatrix4RotateZ(matrix, self.localRotation.z);
    
    return GLKMatrix4MultiplyVector3(matrix, vector);
}

- (GLKVector3)up {
    return [self rotateVector:GLKVector3Make(0, 1, 0)];
}

- (GLKVector3)forward {
    return [self rotateVector:GLKVector3Make(0, 0, 1)];
}

- (GLKVector3)left {
    return [self rotateVector:GLKVector3Make(1, 0, 0)];
}

// Get a quaternion that describes our orientation in world space
- (GLKQuaternion)rotation {
    
    // First, get the identity quaternion (i.e. no rotation)
    GLKQuaternion rotation = GLKQuaternionIdentity;
    
    // Now, multiply this rotation with its parent, if it has one
    if (self.parent)
        rotation = GLKQuaternionMultiply(rotation, self.parent.rotation);
    
    // Finally, rotate around our local axes
    GLKQuaternion xRotation = GLKQuaternionMakeWithAngleAndVector3Axis(self.localRotation.x, GLKVector3Make(1, 0, 0));
    GLKQuaternion yRotation = GLKQuaternionMakeWithAngleAndVector3Axis(self.localRotation.y, GLKVector3Make(0, 1, 0));
    GLKQuaternion zRotation = GLKQuaternionMakeWithAngleAndVector3Axis(self.localRotation.z, GLKVector3Make(0, 0, 1));
    
    rotation = GLKQuaternionMultiply(rotation, xRotation);
    rotation = GLKQuaternionMultiply(rotation, yRotation);
    rotation = GLKQuaternionMultiply(rotation, zRotation);
    
    return rotation;
    
}

// Get our position in world space
- (GLKVector3)position {
    GLKVector3 position = self.localPosition;
    
    if (self.parent)
        position = GLKVector3Add(position, self.parent.position);
    
    return position;
}

// Get our scale in world space
- (GLKVector3)scale {
    GLKVector3 scale = self.localScale;
    
    if (self.parent)
        scale = GLKVector3Multiply(scale, self.parent.scale);
    
    return scale;
}


// Create a matrix that represents our position, rotation and scale in world space
- (GLKMatrix4)localToWorldMatrix {
    
    // First, get the identity matrix
    GLKMatrix4 matrix = GLKMatrix4Identity;
    
    // Next, get the matrix of our parent
    if (self.parent)
        matrix = GLKMatrix4Multiply(matrix, self.parent.localToWorldMatrix);
    
    // Translate it..
    matrix = GLKMatrix4TranslateWithVector3(matrix, self.localPosition);
    
    // Rotate it..
    matrix = GLKMatrix4RotateX(matrix, self.localRotation.x);
    matrix = GLKMatrix4RotateY(matrix, self.localRotation.y);
    matrix = GLKMatrix4RotateZ(matrix, self.localRotation.z);
    
    // And scale it!
    matrix = GLKMatrix4ScaleWithVector3(matrix, self.localScale);
    
    return matrix;
    
}

- (void) translate:(GLKVector3)offset {
    _localPosition = GLKVector3Add(_localPosition, offset);
}

- (void) rotate:(GLKVector3)angles {
    _localRotation = GLKVector3Add(_localRotation, angles);
}

- (void) scale:(GLKVector3)scaleAmounts {
    _localScale = GLKVector3Multiply(_localScale, scaleAmounts);
}

@end
