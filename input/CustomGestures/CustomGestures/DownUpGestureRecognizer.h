//
//  DownUpGestureRecognizer.h
//  CustomGestures
//
//  Created by Jon Manning on 13/08/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DownUpGestureMovingDown = 0,
    DownUpGestureMovingUp
} UpDownGesturePhase;

@interface DownUpGestureRecognizer : UIGestureRecognizer

@property (assign) UpDownGesturePhase phase;

@end
