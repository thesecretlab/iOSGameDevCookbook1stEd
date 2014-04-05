//
//  Camera.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Camera.h"
#import "Transform.h"
#import "GameObject.h"

@implementation Camera

// By default, start with a clear colour of black (RBGA 1,1,1,0)
- (id)init
{
    self = [super init];
    if (self) {
        self.clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    }
    return self;
}

- (void) prepareToDraw {
    // Clear the contents of the screen
    glClearColor(self.clearColor.r, self.clearColor.g, self.clearColor.b, self.clearColor.a);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

// Returns a matrix that maps world-space to view-space
- (GLKMatrix4)viewMatrix {
    
    Transform* transform = self.gameObject.transform;
    
    // the camera's position is it's transform's position in world space
    GLKVector3 position = transform.position;
    
    // the camera's target is right in front of it
    GLKVector3 target = GLKVector3Add(position, transform.forward);
    
    // the camera's up direction is the transform's up direction
    GLKVector3 up = transform.up;
    
    return GLKMatrix4MakeLookAt(position.x, position.y, position.z,
                                target.x, target.y, target.z,
                                up.x, up.y, up.z);
    
}

// Returns a matrix that maps view-space into eye-space
- (GLKMatrix4)projectionMatrix {
    
    // We'll assume that the camera is always rendering into the entire screen
    // (that is, it's never rendering to just a subsection if it.)
    // This means that the aspect ratio of the camera is the screen's aspect ratio.
    
    float aspectRatio = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
    
    return GLKMatrix4MakePerspective(self.fieldOfView, aspectRatio, self.nearClippingPlane, self.farClippingPlane);
}

@end
