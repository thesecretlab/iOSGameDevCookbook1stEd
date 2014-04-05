//
//  Component.h
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameObject;

// A component, which is attached to a game object.
@interface Component : NSObject

// Weak reference to the gameObject we're attached to
@property (weak) GameObject* gameObject;

// Called once per frame to update everything
- (void) update:(float)deltaTime;

@end
