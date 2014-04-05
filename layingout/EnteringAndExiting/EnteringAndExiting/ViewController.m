//
//  ViewController.m
//  EnteringAndExiting
//
//  Created by Jon Manning on 17/10/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    // Called when the application becomes the active one (that is, nothing's covering it up)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Called when the application will enter the foreground (that is, the user left another app and entered this one)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // Called when the application will resign active (that is, something's covering it up, like the notification tray or a phone call)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    // Called when the application enters the background (that is, the user left it)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
}

- (void) applicationDidBecomeActive:(NSNotification*)notification {
    NSLog(@"Application did become active!");
}

- (void) applicationWillResignActive:(NSNotification*)notification {
    NSLog(@"Application will resign active!");
}

- (void) applicationDidEnterBackground:(NSNotification*)notification {
    NSLog(@"Application did enter background!");
}

- (void) applicationWillEnterForeground:(NSNotification*)notification {
    NSLog(@"Application will enter foreground!");
}



- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
