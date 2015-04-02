//
//  GameOfFifteen.m
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioSamplePlayer.h"
#import "TileMove.h"
#import "GameOfFifteen.h"

@interface GameOfFifteen() {
    BOOL shouldAnimateButtons;
    NSMutableArray *tileButtonsToAnimate;
}

@property (nonatomic, strong) NSMutableArray *tileButtons;
@property (weak, nonatomic) IBOutlet UIButton *emptyTileButton;
@property (nonatomic, strong) NSMutableArray *solvedPuzzleConfiguration;
@property (nonatomic, strong) AudioSamplePlayer *asp;

@end

BOOL debug = YES;

@implementation GameOfFifteen


- (id)initWithTileButtons: (NSMutableArray *) tileButtons
{
    self = [super init];
    if (self)
    {
//        My program was crashing, because I set the self.tileButtons pointer to the UI object, and tried to change it in this class.
//        The correct action is to make a full copy of the array, as is done below.
//        [self.tileButtons addObjectsFromArray:tileButtons]; // or is it...
//        I changed the UI from NSArray to Mutable and I've had a change of heart ( so far ) because my whole plan involves comparing objects with the same memory address... if I duplicate the array, they are different...
        self.tileButtons = tileButtons;
        self.solvedPuzzleConfiguration = [[NSMutableArray alloc] init]; // So much trouble by forgetting to alloc/init...
        for (NSObject *b in [self tileButtons]) {
            if (debug) {
                NSLog(@"Add %@ to solvedPuzzleConfiguration", b);
            }
            [self.solvedPuzzleConfiguration addObject:b];
        }
        if (debug) {
            NSLog(@"solvedPuzzleConfiguration size is now %d", [self.solvedPuzzleConfiguration count]);
        }
        self.emptyTileButton = [self.tileButtons objectAtIndex:15];
        self.tileButtonsToAnimate = [[NSMutableArray alloc] init ];
        self.asp = [[AudioSamplePlayer alloc] init];
        self.isResetting = NO;
        self.isShuffling = NO;
        [self.asp loadSoundNamed:@"level1" withFileName:@"level1" andExtension:@"caf"];
        [self.asp loadSoundNamed:@"slide" withFileName:@"slide" andExtension:@"caf"];
        [self.asp loadSoundNamed:@"error" withFileName:@"error" andExtension:@"caf"];
        [self.asp loadSoundNamed:@"reset" withFileName:@"reset" andExtension:@"caf"];
        [self.asp loadSoundNamed:@"shuffle" withFileName:@"shuffle" andExtension:@"caf"];    
        [self.asp playSoundNamed:@"level1"];
        
//        Display tiles in solved configuratiog
        self.arrayOfTileMoves = [[NSMutableArray alloc] init];
    }
    return self;
}

-(UIButton *) generateARandomMove
{
    NSArray *neighborsOfEmptyTileButton = [self getIndexesOfNeighborButtonsOfEmptyTileButton];
    int arrayCount = [neighborsOfEmptyTileButton count];
    int theChosenIndex = rand() % arrayCount;
//    int randomlyChosenIndexOfCount = [[neighborsOfEmptyTileButton objectAtIndex:theChosenIndex] integerValue];
    if (debug) {
        NSLog(@"theChosenIndex: %d", theChosenIndex);
    }
    UIButton *b = [self.tileButtons objectAtIndex:[neighborsOfEmptyTileButton[theChosenIndex] integerValue]];
    return b;
}

-(void) setIsResetting:(BOOL)isResetting
{
    if (isResetting == YES) {
        _isResetting = YES;
        [self.asp playSoundNamed:@"reset"];
    }
    else {
        _isResetting = NO;
        [self.tileButtonsToAnimate removeAllObjects];
    }
}

-(void) setIsShuffling:(BOOL)isShuffling
{
    if (isShuffling == YES) {
        _isShuffling = YES;
        [self.asp playSoundNamed:@"shuffle"];
    }
    else
        _isShuffling = NO;
}

-(BOOL) isPuzzleSolved
{
    if (debug) {
        NSLog(@"isPuzzleSolved method");
        NSLog(@"array1: %@",self.solvedPuzzleConfiguration);
        NSLog(@"array2: %@",self.tileButtons);
    }
    BOOL isSolved = YES;
    if (debug) {
        NSLog(@"self.solvedPuzzleConfiguration count is %d", [[self solvedPuzzleConfiguration] count]);
    }
    for (int i = 0; i < [self.solvedPuzzleConfiguration count]; i++) {
        if (self.tileButtons[i] == self.solvedPuzzleConfiguration[i]) { // an Objective-c nuance is that preceeding ! before comparing these two objects is not the negation! So much pain...
            if (debug) {
                NSLog(@"self.solvedPuzzleConfiguration[%d]: %@ is equal to self.tileButtons[%d]: %@", i, self.solvedPuzzleConfiguration[i], i, self.tileButtons[i]);
            }
        }
        else {
            isSolved = NO;
            if (debug) {
                NSLog(@"self.solvedPuzzleConfiguration[%d]: %@ is NOT equal to self.tileButtons[%d]: %@", i, self.solvedPuzzleConfiguration[i], i, self.tileButtons[i]);
            }
        }
    }
    return isSolved;
}

-(void) didTapTileButton:(UIButton *)tileButton
{

    NSArray *neighborsOfEmptyTileButton = [self getIndexesOfNeighborButtonsOfEmptyTileButton];
    bool tileIsANeighbor = false;
    if (debug) {
        NSLog(@"neighborsOfEmptyTileButton size is: %d", [neighborsOfEmptyTileButton count]);
        NSLog(@"neighborsOfEmptyTileButton contains: %@", neighborsOfEmptyTileButton);
    }
//    if (debug) {
//        NSLog(@"Printing object via for object..");
//        for (id object in neighborsOfEmptyTileButton) {
//            NSLog(object);
//        }
//    }
    
    for (int i = 0; i < [neighborsOfEmptyTileButton count]; i++) {
        int neighborIndex = [[neighborsOfEmptyTileButton objectAtIndex:i] integerValue]; // So much pain by not having integerValue method...
        if (debug) {
            NSLog(@"i: neighborIndex is %d", neighborIndex);
        }
        if (tileButton ==  [[self tileButtons] objectAtIndex:neighborIndex]) {
            tileIsANeighbor = true;
            int emptyTileButtonIndex = [[self tileButtons] indexOfObject:[self emptyTileButton]];
            
//            Make the switch in the array.
            [[self tileButtons] replaceObjectAtIndex:emptyTileButtonIndex withObject:tileButton];
            [[self tileButtons] replaceObjectAtIndex:neighborIndex withObject:self.emptyTileButton];
            
            
            self.shouldAnimateButtons = true; // Don't forget to set this to false via the UI afterwards.
            if (! self.isResetting) {
                [[self arrayOfTileMoves] addObject:tileButton];
                [self.asp playSoundNamed:@"slide"];
            }
            if (! self.isResetting) {
                [self.tileButtonsToAnimate removeAllObjects];
            }
            [[self tileButtonsToAnimate] addObject:tileButton];
//            [self.tileButtonsToAnimate addObject:self.emptyTileButton];
            if (debug) {
                NSLog(@"%@ is a neighbor!", tileButton);
            }
        }
    }
    if (! tileIsANeighbor) {
        [self.asp playSoundNamed:@"error"];
    }
    

}

//-(NSArray*) getTileButtonsToAnimate
//{
//    return tileButtonsToAnimate;
//}

-(NSMutableArray *) getIndexesOfNeighborButtonsOfEmptyTileButton
{
    int emptyTileButtonIndex = [[self tileButtons] indexOfObject:[self emptyTileButton]];
    
    if (debug)
        NSLog(@"The empty is at index: %d", emptyTileButtonIndex);
    
    //    Search high and low and all around.
    NSMutableArray *neighborsIdxArr = [[NSMutableArray alloc] init];
    
    //    Up
    int upInd = emptyTileButtonIndex - 4;
    if (upInd >= 0) {
        //        WHY must it be like below??? That's rediculous. It should work as:
        //        [neighborsIdxArr addObject:upInd]; but doesn't -- it complains about attempting to convert non-objc to objc- item. Essentially this is being double-cast. Rediculous.
        [neighborsIdxArr addObject:[NSNumber numberWithInteger:upInd]];
    }
    
    //    Down
    int downInd = emptyTileButtonIndex + 4;
    if (downInd <= 15) {
        [neighborsIdxArr addObject:[NSNumber numberWithInteger:downInd]];
    }
    
    //    Left
    int leftInd = emptyTileButtonIndex - 1;
    float l1 = ceil(emptyTileButtonIndex/4);
    float l2 = ceil(leftInd/4);
    if (leftInd >= 0 && l1 == l2) {
        [neighborsIdxArr addObject:[NSNumber numberWithInteger:leftInd]];
    }
    
    //    Right
    int rightInd = emptyTileButtonIndex + 1;
    float r1 = ceil(emptyTileButtonIndex/4);
    float r2 = ceil(rightInd/4);
    if (rightInd <= 15 && r1 == r2) {
        [neighborsIdxArr addObject:[NSNumber numberWithInteger:rightInd]];
    }
    
    if (debug) {
        NSLog(@"NeighborsIdxArr has %@", neighborsIdxArr);
    }
    
    return neighborsIdxArr;
}

-(BOOL) shouldTheGameContinue
{
    return true;
//    Just to compile
}

@end