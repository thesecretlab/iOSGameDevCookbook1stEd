//
//  ViewController.m
//  ComponentBasedLayout
//
//  Created by Jon Manning on 17/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"
#import "Entity.h"
#import "Component.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Make a new entity
    Entity* entity = [[Entity alloc] init];
    
    // Add some components
    Component* component = [[Component alloc] init];
    [entity addComponent:component];
    
    // When the game needs to update, send all entities the 'update' message
    // This makes all components get updated as well
    [entity update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
