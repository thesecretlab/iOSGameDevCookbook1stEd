//
//  Entity.m
//  ComponentBasedLayout
//
//  Created by Jon Manning on 17/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "Entity.h"

@implementation Entity {
    NSMutableSet* _components;
}

@synthesize components = _components;

- (id)init {
    self = [super init];
    
    if (self) {
        _components = [NSMutableSet set];
    }
    
    return self;
}

- (void)addComponent:(Component *)component {
    [_components addObject:component];
}

- (void)removeComponent:(Component *)component {
    [_components removeObject:component];
}

- (void)update {
    for (Component* component in _components) {
        [component update];
    }
}

@end
