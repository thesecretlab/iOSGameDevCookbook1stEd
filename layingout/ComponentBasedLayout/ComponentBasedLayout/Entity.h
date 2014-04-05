//
//  Entity.h
//  ComponentBasedLayout
//
//  Created by Jon Manning on 17/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"

@interface Entity : NSObject

@property (strong) NSSet* components;

- (void) addComponent:(Component*)component;
- (void) removeComponent:(Component*)component;

- (void) update;

@end
