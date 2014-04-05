//
//  Material.h
//  MeshLoading
//
//  Created by Jon Manning on 11/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

enum MaterialAttributes {
    MaterialAttributePosition,
    MaterialAttributeNormal,
    MaterialAttributeColor,
    MaterialAttributeTextureCoordinates
};

@interface Material : GLKBaseEffect <GLKNamedEffect>

+ (Material*)effectWithVertexShaderNamed:(NSString*)vertexShaderName fragmentShaderNamed:(NSString*)fragmentShaderName error:(NSError**)error;

- (void) prepareToDraw;

@end
