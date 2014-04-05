//
//  MeshLoader.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Component.h"
#import <GLKit/GLKit.h>


typedef struct {
    GLKVector3 position;
    GLKVector3 normal;
    GLKVector4 color;
    GLKVector2 textureCoordinates;
} Vertex;

typedef struct {
    GLuint vertex1;
    GLuint vertex2;
    GLuint vertex3;
} Triangle;

@interface Mesh : NSObject

+ (Mesh*) meshWithContentsOfURL:(NSURL*)url error:(NSError**)error;

// the name of the OpenGL buffer containing vertex data
@property (readonly) GLuint vertexBuffer;

// the name of the OpenGL buffer containing the triangle list
@property (readonly) GLuint indexBuffer;

// pointer to the loaded array of vector info
@property (readonly) Vertex* vertexData;

// number of vertices
@property (readonly) NSUInteger vertexCount;

// pointer to the triangle list data
@property (readonly) Triangle* triangleData;

// number of triangles
@property (readonly) NSUInteger triangleCount;

@end
