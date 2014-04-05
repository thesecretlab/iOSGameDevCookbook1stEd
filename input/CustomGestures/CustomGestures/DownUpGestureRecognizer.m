//
//  DownUpGestureRecognizer.m
//  CustomGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "DownUpGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface DownUpGestureRecognizer ()

@end

@implementation DownUpGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.phase = DownUpGestureMovingDown;
    self.state = UIGestureRecognizerStatePossible;
    
    // If there's more than one touch, this is not the type of gesture
    // we're looking for, so fail immediately
    if (self.numberOfTouches > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // We know we only have one touch, beacuse touchesBegan will stop
    // recognizing when more than one touch is
    UITouch* touch = [touches anyObject];
    
    // Get the current and previous position of the touch
    CGPoint position = [touch locationInView:touch.view];
    CGPoint lastPosition = [touch previousLocationInView:touch.view];
    
    
    // If the state is Possible, and the touch has moved down, the
    // gesture has Begun
    if (self.state == UIGestureRecognizerStatePossible) {
        if (position.y > lastPosition.y) {
            self.state = UIGestureRecognizerStateBegan;
        }
    }
    
    // If the state is Begun or Changed, and the touch has moved, the
    // gesture will change state
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        
        // If the phase of the gesture is MovingDown, and the touch moved
        // down, the gesture has Changed
        if (self.phase == DownUpGestureMovingDown && position.y > lastPosition.y) {
            self.state = UIGestureRecognizerStateChanged;
        }
        // If the phase of the gesture is MovingDown, and the touch moved
        // up, the gesture has Changed; also, change the phase to MovingUp
        if (self.phase == DownUpGestureMovingDown && position.y < lastPosition.y) {
            self.phase = DownUpGestureMovingUp;
            self.state = UIGestureRecognizerStateChanged;
        }
        // If the phase of the gesture is MovingUp, and the touch moved
        // down, then the gesture has Cancelled
        if (self.phase == DownUpGestureMovingUp && position.y > lastPosition.y) {
            self.state = UIGestureRecognizerStateCancelled;
        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // We know that there's only one touch.
    
    // If the touch ends while the phase is MovingUp, the gesture has
    // Ended. If the touch ends while the phase is MovingDown, the gesture
    // has Failed.
    
    if (self.phase == DownUpGestureMovingDown) {
        self.state = UIGestureRecognizerStateFailed;
    } else if (self.phase == DownUpGestureMovingUp) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

@end
