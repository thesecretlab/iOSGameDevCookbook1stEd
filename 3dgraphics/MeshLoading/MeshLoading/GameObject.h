//
//  GameObject.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Component;

@interface GameObject : NSObject

@property (strong) NSSet* components;

- (void) addComponent:(Component*)component;
- (void) removeComponent:(Component*)component;

- (id)componentWithType:(Class)componentType;
- (NSArray*)componentsWithType:(Class)componentType;

- (void)update:(float)deltaTime;

@end

@class Transform;
@class MeshRenderer;
@class Mesh;
@class Camera;

@interface GameObject (GameObjectComponentAccess)

@property (readonly) Transform* transform;
@property (readonly) MeshRenderer* meshRenderer;
@property (readonly) Camera* camera;

@end