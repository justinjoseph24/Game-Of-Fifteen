//
//  AudioSamplePlayer.m
//  NewSimonSays
//
//  Created by Justin Amburn on 2/21/15.
//  I used sample code from http://ohno789.blogspot.com/2013/08/openal-on-ios.html,  http://ohno789.blogspot.com/2013/08/playing-audio-samples-using-openal-on.html#comment-form, and http://benbritten.com/2009/05/02/lots-and-lots-of-sounds-in-openal/ as a starting point for the OpenAl audio player. The end result is this sound class is an amalgamation of samples and changes based on my project requirments.

//  I'm the author of the music and sounds.

//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioSamplePlayer.h"

@implementation AudioSamplePlayer

static ALCdevice *openALDevice;

static ALCcontext *openALContext;

static NSMutableDictionary *soundBuffers;

- (id)init
{
    self = [super init];
    if (self)
    {
        openALDevice = alcOpenDevice(NULL);
        
        openALContext = alcCreateContext(openALDevice, NULL);
        alcMakeContextCurrent(openALContext);
        soundBuffers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) playSoundNamed:(NSString *)name
{
//    NSLog(@"Try to play sound %@", name);
//    NSLog(@"First check to see what's in the buffer dict...");
//    for (id object in soundBuffers) {
//        NSLog(object);
//    }
    ALuint outputBuffer = (ALuint)[[soundBuffers objectForKey:name] intValue];
    NSUInteger sourceID;
    alGenSources(1, &sourceID);
//
//    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"level1" ofType:@"caf"];
//    NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
//    
//    AudioFileID afid;
//    OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);
//    
//    if (0 != openAudioFileResult)
//    {
//        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", audioFilePath, openAudioFileResult);
//        return;
//    }
//    
//    UInt64 audioDataByteCount = 0;
//    UInt32 propertySize = sizeof(audioDataByteCount);
//    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataByteCount);
//    
//    if (0 != getSizeResult)
//    {
//        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", audioFilePath, getSizeResult);
//    }
//    
//    UInt32 bytesRead = (UInt32)audioDataByteCount;
//    
//    void *audioData = malloc(bytesRead);
//    
//    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
//    
//    if (0 != readBytesResult)
//    {
//        NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", audioFilePath, readBytesResult);
//    }
//    
//    AudioFileClose(afid);
//    
//    ALuint outputBuffer;
//    alGenBuffers(1, &outputBuffer);
    
//    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
    
//    if (audioData)
//    {
//        free(audioData);
//        audioData = NULL;
//    }
    
    alSourcef(sourceID, AL_PITCH, 1.0f);
    alSourcef(sourceID, AL_GAIN, 1.0f);
    
    alSourcei(sourceID, AL_BUFFER, outputBuffer);
    
    alSourcePlay(sourceID);
//    NSLog(@"Reached end of playSoundNamed method");
}

- (void)loadSoundNamed:(NSString *)name withFileName:(NSString *)fileName andExtension:(NSString *)extension {
    // don't load the sound if it's already been loaded
    if ([soundBuffers objectForKey:name]) return;
    
    //
    // open the audio file
    //
    
    // get a reference to the audio file.
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    // the AudioFileID is an opaque identifier that Audio File Services
    // uses to refer to the audio file
    AudioFileID afid;
    
    // open the file and get an AudioFileID for it. 0 indicates we're not
    // providing a file type hint because the file name extension will suffice.
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &afid);
    
    if (0 != openResult) {
        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
        return;
    }
    
    //
    // determine the size of the audio file
    //
    
    // when getting properties, you provide a reference to a variable
    // containing the size of the property value. this variable is then
    // set to the actual size of the property value.
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    
    if (0 != getSizeResult) {
        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", filePath, getSizeResult);
    }
    
    UInt32 bytesRead = (UInt32)fileSizeInBytes;
    
    //
    // read the audio data from the file and put it into the output buffer
    //
    
    // allocate memory to hold the file
    void* audioData = malloc(bytesRead);
    
    // false means we don't want the data cached. 0 means read from the beginning.
    // bytesRead will end up containing the actual number of bytes read.
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    
    if (0 != readBytesResult) {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", filePath, readBytesResult);
    }
    
    // close the file
    AudioFileClose(afid);
    
    // buffers hold the audio data.
    // generate a single output buffer and note its numeric identifier.
    // this allocates memory.
    ALuint outputBuffer;
    alGenBuffers(1, &outputBuffer);
//    [self checkOpenAlError:@"gen buffer"];
    
    // copy the data into the output buffer
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
//    [self checkOpenAlError:@"buffer data"];
    
    // keep a reference to the buffer id
    [soundBuffers setObject:[NSNumber numberWithInt:outputBuffer] forKey:name];
    
    // clean up audio data
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
}

@end