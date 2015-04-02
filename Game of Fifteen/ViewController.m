//
//  ViewController.m
//  Game of Fifteen
//
//  Created by Justin Amburn on 2/21/15.
//  Copyright (c) 2015 Justin Amburn. All rights reserved.
//

#import "ViewController.h"
#import "GameOfFifteen.h"

@interface ViewController ()
{
    BOOL animationInProgress;
    BOOL debug;
}

@property (atomic, strong) NSMutableArray *tileButtons;
@property (atomic, strong) GameOfFifteen *gof;
@property (atomic, strong) NSTimer *animationTimer;

@property (weak) IBOutlet UIButton *tile1Button;
@property (weak, nonatomic) IBOutlet UIButton *tile2Button;
@property (weak, nonatomic) IBOutlet UIButton *tile3Button;
@property (weak, nonatomic) IBOutlet UIButton *tile4Button;
@property (weak, nonatomic) IBOutlet UIButton *tile5Button;
@property (weak, nonatomic) IBOutlet UIButton *tile6Button;
@property (weak, nonatomic) IBOutlet UIButton *tile7Button;
@property (weak, nonatomic) IBOutlet UIButton *tile8Button;
@property (weak, nonatomic) IBOutlet UIButton *tile9Button;
@property (weak, nonatomic) IBOutlet UIButton *tile10Button;
@property (weak, nonatomic) IBOutlet UIButton *tile11Button;
@property (weak, nonatomic) IBOutlet UIButton *tile12Button;
@property (weak, nonatomic) IBOutlet UIButton *tile13Button;
@property (weak, nonatomic) IBOutlet UIButton *tile14Button;
@property (weak, nonatomic) IBOutlet UIButton *tile15Button;
@property (weak, nonatomic) IBOutlet UIButton *blankButton;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *youWinButton;
@property (weak, nonatomic) IBOutlet UISlider *uiSlider;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.youWinButton setAlpha:0];
    self.gof = [[GameOfFifteen alloc] initWithTileButtons:self.tileButtons];
    debug = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)tileButtons
{
    if (!_tileButtons)
        _tileButtons = [NSMutableArray arrayWithObjects:self.tile1Button,
                                                        self.tile2Button, self.tile3Button, self.tile4Button,
                                                        self.tile5Button, self.tile6Button, self.tile7Button,
                                                        self.tile8Button, self.tile9Button, self.tile10Button,
                                                        self.tile11Button, self.tile12Button, self.tile13Button,
                                                        self.tile14Button, self.tile15Button, self.blankButton,
                                                        nil];
    return _tileButtons;
}

- (void)animateTileButtons:(NSEnumerator *)enumerator
{
    if (debug)
    {
        NSLog(@"Animate Tile Buttons Method");
    }
    UIButton *buttonToAnimate = [enumerator nextObject];
    //    UIButton *emptyTileButton = [enumerator nextObject];
    if (!buttonToAnimate)
    {
        if (debug)
        {
            NSLog(@"No button to animate!");
        }
        [self.animationTimer invalidate];
        self.animationTimer = nil;
        animationInProgress = NO;
        return;
    }
    animationInProgress = YES;

    CGRect buttonFrame = buttonToAnimate.frame;
    CGRect emptyFrame = self.blankButton.frame;
    int emptyFrameX = emptyFrame.origin.x;
    int emptyFrameY = emptyFrame.origin.y;
    if (debug)
    {
        NSLog(@"Button coordinates are: %d %d", buttonFrame.origin.x, buttonFrame.origin.y);
        NSLog(@"Empty Button coordinates are: %d %d", emptyFrame.origin.x, emptyFrame.origin.y);
    }

    //    Swap the tile and emptyTile positions... this works.
    //    emptyFrame.origin.x = buttonFrame.origin.x; // new x coordinate
    //    emptyFrame.origin.y = buttonFrame.origin.y; // new y coordinate
    //    buttonFrame.origin.x = emptyFrameX; // new x coordinate
    //    buttonFrame.origin.y = emptyFrameY; // new y coordinate

    emptyFrame.origin.x = buttonFrame.origin.x; // new x coordinate
    emptyFrame.origin.y = buttonFrame.origin.y; // new y coordinate
    buttonFrame.origin.x = emptyFrameX;         // new x coordinate
    buttonFrame.origin.y = emptyFrameY;         // new y coordinate

    float t1 = .10;
    float t2 = 0;

    if ([[self gof] isResetting])
    {
        t1 = .25;
        t2 = .1;
    }

    [UIView animateWithDuration:t1
        delay:t2
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
                        buttonToAnimate.frame = buttonFrame; // move
                        self.blankButton.frame = emptyFrame;
        }
        completion:^(BOOL finished) {
                         [self animateTileButtons:enumerator];

        }];
    //                     completion:nil]; // no completion handler

    //    buttonToAnimate.frame = buttonFrame;

    //    [UIView animateWithDuration:2.f animations:^{
    //        [scrollView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    //    } completion:^(BOOL finished) {
    //        [self.delegate resumeNavigation];
    //    }];

    //    emptyTileButton.frame = emptyFrame;
    [[self gof] setShouldAnimateButtons:NO];
    animationInProgress = NO;
    if (debug)
    {
        NSLog(@"Exit animateTileButtons method");
    }
}

- (IBAction)didTapTileButton:(UIButton *)sender
{
    NSLog(@"tile button pressed %@", sender);
    if (animationInProgress)
        return;
    [self.gof didTapTileButton:sender];
    if ([[self gof] shouldAnimateButtons])
    {
        if (debug)
        {
            NSLog(@"GOF says shouldAnimateButtons");
        }

        //    if( ! [self.gof shouldTheGameContinue] ) {
        //        [self.gameOverButton setAlpha:1];
        //    } else {
        //        if( [self.gof shouldAnimateButtons] ) {
        NSEnumerator *buttonsToAnimate = [[self.gof tileButtonsToAnimate] objectEnumerator];
        //
        [self animateTileButtons:buttonsToAnimate];

        if ([[self gof] isPuzzleSolved] && ![self.gof isResetting] && ![self.gof isShuffling])
        {
            [self.youWinButton setAlpha:1];
        }

        //        if (debug) {
        //            NSLog(buttonsToAnimate);
        //        }
        //        }
        //    }
    }
}

// Used for reset and shuffle only.
- (IBAction)didTapTileButtons
{
    //    NSLog(@"tile button pressed %@", sender);
    if (animationInProgress)
        return;
    NSEnumerator *enumerator = [[self.gof arrayOfTileMoves] reverseObjectEnumerator];
    NSLog(@"Size of self.gof tileButtonsToAnimate is: %d", [[self.gof tileButtonsToAnimate] count]);
    UIButton *sender = [enumerator nextObject];
    int loop_cnt = 0;
    while (sender)
    {
        ++loop_cnt;
        NSLog(@"Loop cnt: %d ", loop_cnt);
        [self.gof didTapTileButton:sender];
        sender = [enumerator nextObject];
//        if ([[self gof] shouldAnimateButtons])
//        {
//            if (debug)
//            {
//                NSLog(@"GOF says shouldAnimateButtons");
//            }

            //    if( ! [self.gof shouldTheGameContinue] ) {
            //        [self.gameOverButton setAlpha:1];
            //    } else {
            //        if( [self.gof shouldAnimateButtons] ) {
//            NSEnumerator *buttonsToAnimate = [[self.gof tileButtonsToAnimate] reverseObjectEnumerator];
            //
//            [self animateTileButtons:buttonsToAnimate];

//            if ([[self gof] isPuzzleSolved] && ![self.gof isResetting] && ![self.gof isShuffling])
//            {
//                [self.youWinButton setAlpha:1];
//            }

            //        if (debug) {
            //            NSLog(buttonsToAnimate);
            //        }
            //        }
            //    }
//        }
    }
    
    NSEnumerator *enumerator2 = [[self.gof arrayOfTileMoves] reverseObjectEnumerator];
    [self animateTileButtons:enumerator2];
    
}

- (IBAction)didTapResetButton:(UIButton *)sender
{
    //    Walk through the array of moves all the way to square one.
    [[self gof] setIsResetting:YES];
    [self.youWinButton setAlpha:0];
    [self didTapTileButtons];
    //    int arrayCount = [[[self gof] arrayOfTileMoves] count];
    //    if (debug)
    //    {
    //        NSLog(@"didTapResetButton: arrayCount of arrayOfTileMoves is %d ", arrayCount);
    //    }
    //    while (arrayCount > 0)
    //    {
    //        NSMutableArray *arrayTmp = [self.gof arrayOfTileMoves];
    //        UIButton *tmp = arrayTmp[arrayCount - 1];
    //        [self didTapTileButton:tmp];
    //        [arrayTmp removeLastObject];
    //        --arrayCount;
    //    }
    [[self gof] setIsResetting:NO];
//    [self.gof.arrayOfTileMoves removeAllObjects];
    self.gof = [[GameOfFifteen alloc] initWithTileButtons:self.tileButtons];
    NSLog(@"Size of [[self.gof arrayOfTileMoves] is %d", [[self.gof arrayOfTileMoves] count]);
}

- (IBAction)didTapShuffleButton:(UIButton *)sender
{
    [[self gof] setIsShuffling:YES];
    int shuffleSteps = [[self uiSlider] value] * 50;
    for (int i = 0; i < shuffleSteps; i++)
    {
        UIButton *b = [[self gof] generateARandomMove];
        [self didTapTileButton:b];
    }
    [[self gof] setIsShuffling:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
