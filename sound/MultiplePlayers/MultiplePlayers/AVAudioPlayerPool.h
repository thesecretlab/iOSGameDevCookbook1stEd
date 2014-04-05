//
//  AVAudioPlayerPool.h
//  MultiplePlayers
//
//  Created by Jon Manning on 6/09/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAudioPlayerPool : NSObject

+ (AVAudioPlayer*) playerWithURL:(NSURL*)url;

@end
