//
//  AVAudioPlayerPool.m
//  MultiplePlayers
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "AVAudioPlayerPool.h"

NSMutableArray* _players = nil;

@implementation AVAudioPlayerPool

+ (NSMutableArray*) players {
    if (_players == nil)
        _players = [[NSMutableArray alloc] init];
    
    return _players;
}

+ (AVAudioPlayer *)playerWithURL:(NSURL *)url {
    NSMutableArray* availablePlayers = [[self players] mutableCopy];
    
    // Try and find a player that can be reused and is not playing
    [availablePlayers filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(AVAudioPlayer* evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.playing == NO && [evaluatedObject.url isEqual:url];
    }]];
    
    // If we found one, return it
    if (availablePlayers.count > 0) {
        NSLog(@"Reusing player for %@", [url lastPathComponent]);
        return [availablePlayers firstObject];
    }
    
    // Didn't find one? Create a new one
    NSError* error = nil;
    AVAudioPlayer* newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (newPlayer == nil) {
        NSLog(@"Couldn't load %@: %@", url, error);
        return nil;
    }
    
    NSLog(@"Creating new player for %@", [url lastPathComponent]);
    [[self players] addObject:newPlayer];
    
    return newPlayer;
    
}

@end
