//
//  GameObject.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "GameObject.h"
#import "Component.h"
#import "Transform.h"
#import "MeshRenderer.h"
#import "Camera.h"

@implementation GameObject {
    NSMutableSet* _components;
}

@synthesize components = _components;

- (id)init {
    self = [super init];
    
    if (self) {
        _components = [NSMutableSet set];
        
        // Add a Transform, since it's likely that every object will need one
        Transform* transform = [[Transform alloc] init];
        [self addComponent:transform];
    }
    
    return self;
}

- (void)addComponent:(Component *)component {
    [_components addObject:component];
    component.gameObject = self;
}

- (void)removeComponent:(Component *)component {
    component.gameObject = nil;
    [_components removeObject:component];
}

- (id)componentWithType:(Class)componentType {
    // Helper function that just returns the first component with a given type
    return [[self componentsWithType:componentType] firstObject];
}

- (NSArray*)componentsWithType:(Class)componentType {
    // Return nil if the class isn't actually a type of component
    if ([componentType isSubclassOfClass:[Component class]] == NO)
        return nil;
    
    // Work out which components match the component type, and return them all
    return [[_components objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return [obj isKindOfClass:componentType];
    }] allObjects];
}

- (void)update:(float)deltaTime {
    for (Component* component in _components) {
        [component update:deltaTime];
    }
}

@end

@implementation GameObject (GameObjectComponentAccess)

- (Transform *)transform {
    return [self componentWithType:[Transform class]];
}

- (Camera *)camera {
    return [self componentWithType:[Camera class]];
}

- (MeshRenderer *)meshRenderer {
    return [self componentWithType:[MeshRenderer class]];
}




@end






