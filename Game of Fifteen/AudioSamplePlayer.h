//
//  AudioSamplePlayer.h
//  NewSimonSays
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 SSU. All rights reserved.
//

#ifndef NewSimonSays_AudioSamplePlayer_h
#define NewSimonSays_AudioSamplePlayer_h

#import <Foundation/Foundation.h>

#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#include <AudioToolbox/AudioToolbox.h>

@interface AudioSamplePlayer : NSObject

- (void) playSound;
- (void)playSoundNamed:(NSString *)name;
- (void)loadSoundNamed:(NSString *)name withFileName:(NSString *)fileName andExtension:(NSString *)extension;

@end

#endif
