//
//  CardSlot.h
//  DragAndDrop
//
//  Created by Jon Manning on 11/02/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@interface CardSlot : UIImageView

// The card that's currently living in this card slot.
@property (nonatomic, weak) Card* currentCard;

// Whether cards should be deleted if they are dropped on this card
@property (assign) BOOL deleteOnDrop;

@end
