//
//  CustomTapRegion.m
//  TouchRegion
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "CustomTapRegion.h"

@implementation CustomTapRegion

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // A point is inside this view if it falls inside a rectangle that's 40pt
    // larger than the bounds of the view
    
    return CGRectContainsPoint(CGRectInset(self.bounds, -40, -40), point);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
