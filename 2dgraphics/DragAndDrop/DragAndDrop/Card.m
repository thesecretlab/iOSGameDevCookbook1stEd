//
//  Card.m
//  DragAndDrop
//
//  Created by Jon Manning on 11/02/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "Card.h"
#import "CardSlot.h"

@interface Card ()

@property (strong) UIPanGestureRecognizer* dragGesture;

@end

@implementation Card

// Creates a card, and
- (id)initWithCardSlot:(CardSlot *)cardSlot {
    
    if (cardSlot.currentCard != nil) {
        // This card slot already has a card, and can't have another.
        return nil;
    }
    
    // All cards use the same image.
    self = [self initWithImage:[UIImage imageNamed:@"Card"]];
    
    if (self) {
        // Cards appear at the same position as the card slot.
        self.center = cardSlot.center;
        
        // We're using this slot as our current card slot
        self.currentSlot = cardSlot;
        
        // Create and set up the drag gesture
        self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
        [self addGestureRecognizer:self.dragGesture];
        
        // UIImageViews default to userInteractionEnabled to NO; turn it on.
        self.userInteractionEnabled = YES;
    }
    
    return self;
    
}

// Called when the drag gesture recognizer changes state.
- (void) dragged:(UIPanGestureRecognizer*)dragGestureRecognizer {
    
    // If we've started dragging...
    if (dragGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // The drag has moved enough such that it's decided that a pan is happening.
        // We need to animate to the right location
        CGPoint translation = [dragGestureRecognizer translationInView:self.superview];
        
        translation.x += self.center.x;
        translation.y += self.center.y;
        
        // Animate to where the drag is at right now, and rotate by a few degrees
        [UIView animateWithDuration:0.1 animations:^{
            self.center = translation;
            
            // Rotate by about 5 degrees
            self.transform = CGAffineTransformMakeRotation(M_PI_4 / 8.0);
        }];
        
        // Reset the drag
        [dragGestureRecognizer setTranslation:CGPointZero inView:self.superview];
        
        // Bring the card up to the front so that it appears over everything
        [self.superview bringSubviewToFront:self];
        
    } else if (dragGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // The drag location has changed. Update the card's position.
        
        CGPoint translation = [dragGestureRecognizer translationInView:self.superview];
        
        translation.x += self.center.x;
        translation.y += self.center.y;
        
        self.center = translation;
        
        [dragGestureRecognizer setTranslation:CGPointZero inView:self.superview];
    } else if (dragGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // The drag has finished.

        // If the touch is over a CardSlot, and that card slot doesn't already have a card, then we're now
        // in that slot, and we should move it; otherwise, return to the previous slot.
        
        CardSlot* destinationSlot = nil;
        
        // Loop over every view
        for (UIView* view in self.superview.subviews) {
            
            // First, check to see if the drag is inside the view; if not, move on
            if ([view pointInside:[dragGestureRecognizer locationInView:view] withEvent:nil] == NO)
                continue;
            
            // If the view the drag is inside the view, check to see if the view is a CardSlot. If it is,
            // and it's got no card, then it's our destination.
            if ([view isKindOfClass:[CardSlot class]]) {
                if ([(CardSlot*)view currentCard] == nil)
                    destinationSlot = (CardSlot*)view;
                break;
            }
        }
        
        // If we have a new destination, update the properties.
        if (destinationSlot) {
            self.currentSlot.currentCard = nil;
            self.currentSlot = destinationSlot;
            self.currentSlot.currentCard = self;
        }
        
        // Animate to our new destination
        [UIView animateWithDuration:0.1 animations:^{
            self.center = self.currentSlot.center;
        }];
    } else if (dragGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        // The gesture was interrupted (for example, because a phone call came in.)
        // Move back to our original slot.
        
        [UIView animateWithDuration:0.1 animations:^{
            self.center = self.currentSlot.center;
        }];
        
    }
    
    // If the gesture ended or was cancelled, we need to return to normal orientation.
    if (dragGestureRecognizer.state == UIGestureRecognizerStateEnded || dragGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        // Rotate back to normal orientation.
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
    
}

// Removes the card from the view after fading out.
- (void) delete {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
