//
//  PerlinNoise.h
//  PerlinNoise
//
//  Created by Jon Manning on 6/03/2014.
//  Copyright (c) 2014 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerlinNoise : NSObject

// The shared noise object.
+ (PerlinNoise*) noise;

// Begins generating a UIImage filled with perlin noise,
// given a size, a persistence value, the number of
// octaves, the random seed to use, and a block to call
// when the image is done.
- (void) imageWithSize:(CGSize)size persistence:(float)persistence octaves:(int)octaves seed:(int) seed completion:(void (^)(UIImage* image))completionBlock;

// Calculates Perlin noise at a position.
- (float) perlinNoiseAtPosition:(CGPoint)position persistence:(float)persistence octaves:(int)octaves seed:(int)seed;

@end
