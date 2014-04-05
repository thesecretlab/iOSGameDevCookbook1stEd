//
//  CardSlot.m
//  DragAndDrop
//
//  Created by Jon Manning on 11/02/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import "CardSlot.h"
#import "Card.h"

@interface CardSlot ()

// The tap gesture recognizer; when the view is tapped, a new Card is created
@property (strong) UITapGestureRecognizer* tap;

@end

@implementation CardSlot

// Called when the view wakes up in the Storyboard.
- (void) awakeFromNib {
    
    // Create and configure the tap recognizer.
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tap];
    
    // UIImageViews default to userInteractionEnabled being set to NO, so change that.
    self.userInteractionEnabled = YES;
}

// Called when the tap recognizer changes state.
- (void) tapped:(UITapGestureRecognizer*)tap {
    
    // If a tap has been recognized, create a new card
    if (tap.state == UIGestureRecognizerStateRecognized) {
        
        // Only card slots that aren't 'delete on drop' can create cards
        if (self.deleteOnDrop == NO) {
            Card* card = [[Card alloc] initWithCardSlot:self];
            
            [self.superview addSubview:card];
            
            self.currentCard = card;
        }
    }
}

// Called by the Card class to transfer ownership of the card.
- (void)setCurrentCard:(Card *)currentCard {
    
    // If we're marked as 'delete on drop' then delete the card and set our current
    // card variable to nil
    if (self.deleteOnDrop) {
        [currentCard delete];
        _currentCard = nil;
        return;
    }
    
    // Otherwise, our current card becomes the new card
    _currentCard = currentCard;
}

@end
