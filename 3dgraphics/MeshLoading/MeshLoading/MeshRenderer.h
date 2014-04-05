//
//  MeshRenderer.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Component.h"
#import "Material.h"
#import <GLKit/GLKit.h>

@class Mesh;
@class Camera;

@interface MeshRenderer : Component

- (void) renderWithCamera:(Camera*)camera;

@property (strong) Mesh* mesh;

@property (strong) Material* effect;

@end
