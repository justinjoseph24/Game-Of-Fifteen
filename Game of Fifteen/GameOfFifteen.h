//
//  GameOfFifteen.h
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#ifndef Game_of_Fifteen_GameOfFifteen_h
#define Game_of_Fifteen_GameOfFifteen_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GameOfFifteen : NSObject
@property (atomic) BOOL shouldAnimateButtons;
@property (atomic) BOOL isResetting;
@property (atomic) BOOL isShuffling;
@property (atomic, strong) NSMutableArray *tileButtonsToAnimate;
@property (atomic, strong) NSMutableArray *arrayOfTileMoves;

//-(void) startGameWithTileButtons: (NSArray *) tileButtons;
-(instancetype) initWithTileButtons: (NSArray *) tileButtons;
-(void) didTapTileButton: (UIButton *) tileButton;
-(BOOL) shouldTheGameContinue;
-(BOOL) isPuzzleSolved;
-(UIButton*) generateARandomMove;
@end

#endif
