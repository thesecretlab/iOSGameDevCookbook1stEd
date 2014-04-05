//
//  Animation.h
//  MeshLoading
//
//  Created by Jon Manning on 11/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Component.h"
#import <GLKit/GLKit.h>

// Animates a property on 'object'; t is between 0 and 1
typedef void (^AnimationBlock)(GameObject* object, float t);

@interface Animation : Component

@property (assign) float duration;

- (void) startAnimating;
- (void) stopAnimating;

- (id) initWithAnimationBlock:(AnimationBlock)animationBlock;

@end
