//
//  Card.h
//  DragAndDrop
//
//  Created by Jon Manning on 11/02/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardSlot;

@interface Card : UIImageView

// Creates a new card, given a card slot for it to exist in.
- (id) initWithCardSlot:(CardSlot*)cardSlot;

// Deletes the card with an animation.
- (void) delete;

// The card slot that we're currently in.
@property (weak) CardSlot* currentSlot;

@end
