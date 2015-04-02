//
//  TileMove.m
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#import "TileMove.h"

@interface TileMove()

@end

@implementation TileMove

-(instancetype) initWithGridLocation:(NSInteger *)gridLocation direction:(NSInteger *)dir
{
    if( (self = [super init]) == nil )
        return nil;
    [self setAGridLocation: gridLocation];
    [self setDirection: dir];
    NSLog(@"Grid location is: %d and direction is %d", gridLocation, dir);
    return self;
}

-(NSInteger) getGridLocation
{
    return *(_aGridLocation);
}

-(NSInteger) getDirection
{
    return _direction;
}

@end