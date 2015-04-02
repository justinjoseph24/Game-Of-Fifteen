//
//  TileMove.h
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#ifndef Game_of_Fifteen_TileMove_h
#define Game_of_Fifteen_TileMove_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TileMove : NSObject

@property (nonatomic) NSInteger *aGridLocation;
@property (nonatomic) NSInteger *direction;

-(instancetype) initWithGridLocation: (NSInteger *) gridLocation direction:(NSInteger *) dir;
-(NSInteger) getGridLocation;
-(NSInteger) getDirection;


@end

#endif
