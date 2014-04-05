//
//  MeshRenderer.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "MeshRenderer.h"
#import "Mesh.h"
#import "GameObject.h"
#import "Camera.h"
#import "Transform.h"

@implementation MeshRenderer

- (id)init
{
    self = [super init];
    if (self) {
        NSError* error = nil;
        _effect = [Material effectWithVertexShaderNamed:@"BaseVertexShader" fragmentShaderNamed:@"VertexColorFragmentShader" error:&error];
        
        if (_effect == nil) {
            NSLog(@"Couldn't create the material: %@", error);
            return nil;
        }
    }
    return self;
}

- (void) renderWithCamera:(Camera*)camera {
    
    // First, ensure that we have a camera to render with
    if (camera == nil)
        return;
    
    // Next, ensure that we've got a mesh to draw
    if (self.mesh == nil)
        return;
    
    // Get the transform, so we know where to draw stuff
    Transform* transform = self.gameObject.transform;
    
    // Get the object's model-view matrix, which converts vertices from model-space to world-space
    GLKMatrix4 modelViewMatrix = transform.localToWorldMatrix;
    
    // Get the camera's view matrix, and combine it with the model view matrix
    GLKMatrix4 viewMatrix = camera.viewMatrix;
    modelViewMatrix = GLKMatrix4Multiply(viewMatrix, modelViewMatrix);
    
    // We now have the final model-view matrix for this model, which defines where the mesh is in view space
    [_effect.transform setModelviewMatrix:modelViewMatrix];
    
    // Get the camera's projection matrix, so that we can map the mesh into screen space
    [_effect.transform setProjectionMatrix:camera.projectionMatrix];
    
    // Tell the GLKEffect that we're about to draw using it
    [_effect prepareToDraw];
    
    // We now start talking to OpenGL:
    
    // "Here's where to find the list of vertices..."
    glBindBuffer(GL_ARRAY_BUFFER, self.mesh.vertexBuffer);
    // "...and here's where to find the list of triangles"
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.mesh.indexBuffer);
    
    // "Here's where to find position info for each vertex..."
    glEnableVertexAttribArray(MaterialAttributePosition);
    glVertexAttribPointer(MaterialAttributePosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, position));
    
    // "Here's where to find color info..."
    glEnableVertexAttribArray(MaterialAttributeColor);
    glVertexAttribPointer(MaterialAttributeColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, color));
    
    // "And normal info..."
    glEnableVertexAttribArray(MaterialAttributeNormal);
    glVertexAttribPointer(MaterialAttributeNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, normal));
    
    // "...and here's where to find texture info."
    glEnableVertexAttribArray(MaterialAttributeTextureCoordinates);
    glVertexAttribPointer(MaterialAttributeTextureCoordinates, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, textureCoordinates));
    
    // "Go!"
    glDrawElements(GL_TRIANGLES, self.mesh.triangleCount * 3, GL_UNSIGNED_INT, 0);
    
}

@end
