//
//  MeshLoader.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Mesh.h"

@implementation Mesh

+ (Mesh *)meshWithContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)error {
    
    // Load the JSON text into memory
    
    NSData* meshJSONData = [NSData dataWithContentsOfURL:url options:0 error:error];
    
    if (meshJSONData == nil)
        return nil;
    
    // Convert the text into an NSDictionary, then check to see if it's actually a dictionary
    NSDictionary* meshInfo = [NSJSONSerialization JSONObjectWithData:meshJSONData options:0 error:error];
    
    if ([meshInfo isKindOfClass:[NSDictionary class]] == NO)
        return nil;
    
    // Finally, attempt to create a mesh with this dictionary
    return [[Mesh alloc] initWithMeshDictionary:meshInfo];
    
}

- (id)initWithMeshDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        
        // Get the arrays of vertices and triangles, and ensure they're arrays
        NSArray* loadedVertexDictionary = dictionary[@"vertices"];
        NSArray* loadedTriangleDictionary = dictionary[@"triangles"];
        
        if ([loadedVertexDictionary isKindOfClass:[NSArray class]] == NO) {
            NSLog(@"Expected 'vertices' to be an array");
            return nil;
        }
        
        if ([loadedTriangleDictionary isKindOfClass:[NSArray class]] == NO) {
            NSLog(@"Expected 'triangles' to be an array");
            return nil;
        }
        
        // Work out how many vertices and triangles we have
        _vertexCount = loadedVertexDictionary.count;
        _triangleCount = loadedTriangleDictionary.count;
        
        // Allocate memory to store the vertices and triangles in
        _vertexData = calloc(sizeof(Vertex), _vertexCount);
        _triangleData = calloc(sizeof(Triangle), _triangleCount);
        
        if (_vertexData == NULL || _triangleData == NULL) {
            NSLog(@"Couldn't allocate memory!");
            return nil;
        }
        
        // For each vertex in the list, read information about it and store it
        for (int vertex = 0; vertex < _vertexCount; vertex++) {
            
            NSDictionary* vertexInfo = loadedVertexDictionary[vertex];
            
            if ([vertexInfo isKindOfClass:[NSDictionary class]] == NO) {
                NSLog(@"Vertex %i is not a dictionary", vertex);
                return nil;
            }
            
            // Store the vertex data in memory, at the correct position:
            
            // Position
            _vertexData[vertex].position.x = [vertexInfo[@"x"] floatValue];
            _vertexData[vertex].position.y = [vertexInfo[@"y"] floatValue];
            _vertexData[vertex].position.z = [vertexInfo[@"z"] floatValue];
            
            // Texture coordinates
            _vertexData[vertex].textureCoordinates.s = [vertexInfo[@"s"] floatValue];
            _vertexData[vertex].textureCoordinates.t = [vertexInfo[@"t"] floatValue];
            
            // Colour
            _vertexData[vertex].color.r = [vertexInfo[@"r"] floatValue];
            _vertexData[vertex].color.g = [vertexInfo[@"g"] floatValue];
            _vertexData[vertex].color.b = [vertexInfo[@"b"] floatValue];
            // If no alpha is supplied, set it to 1.0
            if (vertexInfo[@"a"] == nil)
                _vertexData[vertex].color.a = 1.0;
            else
                _vertexData[vertex].color.a = [vertexInfo[@"a"] floatValue];
            
            
            // Normal
            _vertexData[vertex].normal.x = [vertexInfo[@"nx"] floatValue];
            _vertexData[vertex].normal.y = [vertexInfo[@"ny"] floatValue];
            _vertexData[vertex].normal.z = [vertexInfo[@"nz"] floatValue];
            
            
            
        }
        
        // Next, for each triangle in the list, read information and store it
        for (int triangle = 0; triangle < _triangleCount; triangle++) {
            NSArray* triangleInfo = loadedTriangleDictionary[triangle];
            
            if ([triangleInfo isKindOfClass:[NSArray class]] == NO) {
                NSLog(@"Triangle %i is not an array", triangle);
                return nil;
            }
            
            // Store the index of each referenced vertex
            _triangleData[triangle].vertex1 = [triangleInfo[0] unsignedIntegerValue];
            _triangleData[triangle].vertex2 = [triangleInfo[1] unsignedIntegerValue];
            _triangleData[triangle].vertex3 = [triangleInfo[2] unsignedIntegerValue];
            
            // Check to make sure that the vertices referred to exist
            
            if (_triangleData[triangle].vertex1 >= _vertexCount) {
                NSLog(@"Triangle %i refers to an unknown vertex %i", triangle, _triangleData[triangle].vertex1);
                return nil;
            }
            
            if (_triangleData[triangle].vertex2 >= _vertexCount) {
                NSLog(@"Triangle %i refers to an unknown vertex %i", triangle, _triangleData[triangle].vertex2);
                return nil;
            }
            
            if (_triangleData[triangle].vertex3 >= _vertexCount) {
                NSLog(@"Triangle %i refers to an unknown vertex %i", triangle, _triangleData[triangle].vertex3);
                return nil;
            }
        }
        
        // We've now loaded all of the data into memory. Time to create buffers and give
        // them to OpenGL!
        
        glGenBuffers(1, &_vertexBuffer);
        glGenBuffers(1, &_indexBuffer);
        
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * _vertexCount, _vertexData, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Triangle) * _triangleCount, _triangleData, GL_STATIC_DRAW);
        
        
    }
    return self;
}

- (void)dealloc {
    // We're going away, so we need to tell OpenGL to get rid of the data we uploaded
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
    
    // Now free the memory that we allocated earlier
    free(_vertexData);
    free(_triangleData);
}

@end
