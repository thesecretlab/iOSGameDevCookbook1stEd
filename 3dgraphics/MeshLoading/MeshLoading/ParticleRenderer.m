//
//  ParticleRenderer.m
//  MeshLoading
//
//  Created by Jon Manning on 11/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "ParticleRenderer.h"
#import "GameObject.h"

typedef struct {
    GLKVector3 position;
    GLKVector3 velocity;
    float lifeRemaining;
    BOOL alive;
    
} Particle;

typedef struct {
    GLKVector3 topLeft;
    GLKVector3 topRight;
    GLKVector3 bottomLeft;
    GLKVector3 bottomRight;
} ParticleQuad;

@interface ParticleRenderer()

@property (assign) float emissionRate;
@property (strong) GLKBaseEffect* particleEffect;
@property (assign) GLKVector3 particleVelocity;
@property (assign) GLKVector3 particleAcceleration;
@property (assign) float particleLifespan;

@end

@implementation ParticleRenderer {
    
    NSUInteger particlePoolCount;
    
    Particle* particlePool;
    
    float timeSinceLastParticleEmission;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Create a particle pool
        particlePoolCount = 1024;
        particlePool = calloc(sizeof(Particle), particlePoolCount);
    }
    return self;
}

- (void)update:(float)deltaTime {
    
    timeSinceLastParticleEmission += deltaTime;
    
    float secondsPerParticle = 1.0 / self.emissionRate;
    
    // Emit new particles, if necessary
    while (timeSinceLastParticleEmission > secondsPerParticle) {
        timeSinceLastParticleEmission -= secondsPerParticle;
        
        [self emitParticle];
    }
    
    // Update the position of each particle
    for (int particle = 0; particle < particlePoolCount; particle++) {
        
        // If this particle isn't alive, skip it
        if (particlePool[particle].alive == NO)
            continue;
        
        // If this particle has run out of time, mark it as not alive and skip it
        particlePool[particle].lifeRemaining -= deltaTime;
        if (particlePool[particle].lifeRemaining <= 0) {
            particlePool[particle].alive = NO;
            continue;
        }
        
        GLKVector3 offset = GLKVector3MultiplyScalar(particlePool[particle].velocity, deltaTime);
        
        particlePool[particle].position = GLKVector3Add(particlePool[particle].position, offset);
    }
    
}

- (void) renderWithCamera:(Camera *)camera {
    
    
    
    // Build a mesh for the particles by creating a square for each particle, with updates for each square
    for (int particle = 0; particle < particlePoolCount; particle++) {
        
        
        
    }
}

- (void) emitParticle {
    
    int particleToEmit = -1;
    for (particleToEmit = 0; particleToEmit < particlePoolCount; particleToEmit++) {
        if (particlePool[particleToEmit].alive == NO)
            break;
    }
    
    if (particleToEmit == -1) {
        // resize the particle pool by doubling it
        particleToEmit = particlePoolCount;
        
        particlePoolCount *= 2;
        particlePool = realloc(particlePool, sizeof(Particle) * particlePoolCount);
        
    }
    
    particlePool[particleToEmit].velocity = self.particleVelocity;
    particlePool[particleToEmit].position = GLKVector3Make(0, 0, 0);
    particlePool[particleToEmit].lifeRemaining = self.particleLifespan;
    particlePool[particleToEmit].alive = YES;
    
    
}

@end
