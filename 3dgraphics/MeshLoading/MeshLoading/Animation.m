//
//  Animation.m
//  MeshLoading
//
//  Created by Jon Manning on 11/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Animation.h"

@implementation Animation {
    AnimationBlock _animationBlock;
    
    float _timeElapsed;
    
    BOOL _playing;
    
}

- (void)startAnimating {
    _timeElapsed = 0;
    _playing = YES;
}

- (void)stopAnimating {
    _playing = NO;
}

- (void) update:(float)deltaTime {
    
    // Don't do anything if we're not playing
    if (_playing == NO)
        return;
    
    // Don't do anything if the duration is zero or less
    if (self.duration <= 0)
        return;
    
    // Increase the amount of time that's this animation's been running for
    _timeElapsed += deltaTime;
    
    // Go back to the start when time elapsed > duration
    if (_timeElapsed > self.duration)
        _timeElapsed = 0;
    
    // Dividing the time elapsed by the duration returns a value between 0 and 1
    float t = _timeElapsed / self.duration;
    
    // Finally, call the animation block
    if (_animationBlock) {
        _animationBlock(self.gameObject, t);
    }
}

- (id)initWithAnimationBlock:(AnimationBlock)animationBlock
{
    
    self = [super init];
    if (self) {
        _animationBlock = animationBlock;
        _duration = 2.5;
    }
    return self;
}

@end
